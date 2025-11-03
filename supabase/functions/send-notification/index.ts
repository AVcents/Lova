import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { importPKCS8, SignJWT } from "https://deno.land/x/jose@v4.14.4/index.ts"

// Environment variables
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const FIREBASE_PROJECT_ID = Deno.env.get("FIREBASE_PROJECT_ID")!
const FIREBASE_CLIENT_EMAIL = Deno.env.get("FIREBASE_CLIENT_EMAIL")!
const FIREBASE_PRIVATE_KEY = Deno.env.get("FIREBASE_PRIVATE_KEY")!

// Supabase client
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

// TypeScript types
interface NotificationRequest {
  user_id: string
  title: string
  body: string
  data?: Record<string, any>
}

interface ValidationError {
  error: string
  details?: string[]
}

// Validation helper
function validateRequestBody(body: any): { valid: boolean; errors: string[] } {
  const errors: string[] = []

  if (!body) {
    return { valid: false, errors: ['Request body is required'] }
  }

  if (!body.user_id || typeof body.user_id !== 'string' || body.user_id.trim() === '') {
    errors.push('user_id is required and must be a non-empty string')
  }

  if (!body.title || typeof body.title !== 'string' || body.title.trim() === '') {
    errors.push('title is required and must be a non-empty string')
  }

  if (!body.body || typeof body.body !== 'string' || body.body.trim() === '') {
    errors.push('body is required and must be a non-empty string')
  }

  if (body.data !== undefined && (typeof body.data !== 'object' || body.data === null || Array.isArray(body.data))) {
    errors.push('data must be an object if provided')
  }

  return { valid: errors.length === 0, errors }
}

// Generate OAuth2 access token for FCM
async function getFirebaseAccessToken(): Promise<string> {
  try {
    const alg = "RS256"

    // Transformer les \n littéraux en vrais retours à la ligne
    const formattedKey = FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n')

    const key = await importPKCS8(formattedKey, alg)

    const now = Math.floor(Date.now() / 1000)
    const jwt = await new SignJWT({ scope: "https://www.googleapis.com/auth/firebase.messaging" })
      .setProtectedHeader({ alg, typ: "JWT" })
      .setIssuer(FIREBASE_CLIENT_EMAIL)
      .setSubject(FIREBASE_CLIENT_EMAIL)
      .setAudience("https://oauth2.googleapis.com/token")
      .setIssuedAt(now)
      .setExpirationTime(now + 3600) // 1 hour
      .sign(key)

    const response = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
        assertion: jwt,
      }),
    })

    if (!response.ok) {
      const errorText = await response.text()
      throw new Error(`OAuth token error: ${response.status} ${errorText}`)
    }

    const json = await response.json()
    return json.access_token as string
  } catch (error) {
    throw new Error(`Failed to generate Firebase access token: ${error instanceof Error ? error.message : String(error)}`)
  }
}

// Fetch FCM token from Supabase users table
async function getUserFcmToken(userId: string): Promise<string | null> {
  const { data, error } = await supabase
    .from('users')
    .select('fcm_token')
    .eq('id', userId)
    .single()

  if (error) {
    throw new Error(`Database error: ${error.message}`)
  }

  return data?.fcm_token || null
}

// Send notification via FCM v1 API
async function sendFcmNotification(
  fcmToken: string,
  title: string,
  body: string,
  data?: Record<string, any>
): Promise<string> {
  const accessToken = await getFirebaseAccessToken()
  const url = `https://fcm.googleapis.com/v1/projects/${FIREBASE_PROJECT_ID}/messages:send`

  const payload = {
    message: {
      token: fcmToken,
      notification: {
        title,
        body,
      },
      data: data || {},
      android: {
        priority: "high",
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
          },
        },
      },
    },
  }

  const response = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${accessToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
  })

  const responseText = await response.text()

  if (!response.ok) {
    throw new Error(`FCM error: ${response.status} ${responseText}`)
  }

  try {
    const result = JSON.parse(responseText)
    return result.name as string // "projects/.../messages/{messageId}"
  } catch {
    return responseText
  }
}

serve(async (req: Request) => {
  // CORS headers
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }

  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Only accept POST requests
    if (req.method !== 'POST') {
      return new Response(
        JSON.stringify({ error: 'Method not allowed. Use POST.' }),
        {
          status: 405,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Parse request body
    let requestBody: any
    try {
      requestBody = await req.json()
    } catch (error) {
      return new Response(
        JSON.stringify({ error: 'Invalid JSON in request body' }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Validate request body
    const { valid, errors } = validateRequestBody(requestBody)
    if (!valid) {
      return new Response(
        JSON.stringify({ error: 'Validation failed', details: errors } as ValidationError),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    const { user_id, title, body, data }: NotificationRequest = requestBody

    // Fetch FCM token from database
    let fcmToken: string | null
    try {
      fcmToken = await getUserFcmToken(user_id)
    } catch (error) {
      return new Response(
        JSON.stringify({
          error: 'Failed to fetch user data',
          message: error instanceof Error ? error.message : 'Unknown error',
        }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Check if FCM token exists
    if (!fcmToken) {
      return new Response(
        JSON.stringify({
          error: 'FCM token not found',
          message: `No FCM token found for user_id: ${user_id}`,
        }),
        {
          status: 404,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Send notification via FCM
    let messageId: string
    try {
      messageId = await sendFcmNotification(fcmToken, title, body, data)
    } catch (error) {
      return new Response(
        JSON.stringify({
          error: 'Failed to send notification',
          message: error instanceof Error ? error.message : 'Unknown error',
        }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Success response
    return new Response(
      JSON.stringify({
        success: true,
        message_id: messageId,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )

  } catch (error) {
    console.error('Unexpected error:', error)
    return new Response(
      JSON.stringify({
        error: 'Internal server error',
        message: error instanceof Error ? error.message : 'Unknown error',
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )
  }
})
