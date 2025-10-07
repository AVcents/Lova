En-têtes requis
- Authorization: Bearer <user_jwt>
- Idempotency-Key: <uuid-v4>
- Content-Type: application/json

Erreur standard
{ code: STRING_UPPER, message: string, details: {}, request_id: uuid }

POST /issue_invite
- Body: { ttl_minutes: number, note?: string }
- Réponse 200: { invite_code: string, expires_at: ISO8601 }
- Erreurs: TTL_INVALID, ALREADY_IN_RELATION, RATE_LIMITED

POST /accept_invite
- Body: { invite_code: string, consent_flags: { analysis_opt_in: boolean } }
- Réponse 200: { relation_id: uuid, member_role: "partner" }
- Erreurs: INVITE_NOT_FOUND, INVITE_EXPIRED, INVITE_USED, SELF_JOIN_FORBIDDEN

POST /revoke_relation
- Body: { relation_id: uuid, reason?: string }
- Réponse 200: { status: "revoked" }
- Erreurs: NOT_MEMBER, ALREADY_REVOKED, FORBIDDEN

Règle d’idempotence
- Même Idempotency-Key + même body ⇒ même réponse.
- Clé réutilisée avec body différent ⇒ IDEMPOTENCY_REPLAY.

Événements à logger
invite.issued, invite.accepted, relation.revoked, revoke.denied.

Contrats figés v1.0 - ne pas modifier sans version