# Schéma Supabase LOVA

## Tables principales

### users
- Gérée par Supabase Auth
- Colonnes custom à documenter

### couples
- À documenter

### relations
- À documenter

### messages
- Messages du chat couple (chiffrés côté client)
- À documenter

### game_sessions
- Sessions de jeux couple
- À documenter

### checkins_me
- Check-ins solo
- À documenter

### checkins_couple
- Check-ins couple
- À documenter

## RLS Policies

- À documenter

## Edge Functions

### check-daily-quota
- Vérification du quota quotidien d'utilisation IA
- Contrat d'API à documenter

### classifier-tone
- Classification du ton des messages (pour interventions IA)
- Contrat d'API à documenter

### generate-monthly-insight
- Génération d'insights mensuels
- Contrat d'API à documenter

### generate-sos-response
- Génération de réponses IA pour mode SOS
- Contrat d'API à documenter

### send-notification
- Envoi de notifications push via FCM
- Contrat d'API à documenter

---

*Document à compléter avec les vraies définitions de tables/policies.*
*Voir aussi : `supabase/README_API_CONTRACTS.md` pour les contrats d'API.*
