/*
ESTE ARCHIVO ES UNA GUÍA. NO SE USA POR DEFECTO.

Para ranking ONLINE con Firebase (Firestore):

1) Agrega a pubspec.yaml:
   firebase_core: ^...
   cloud_firestore: ^...

2) Configura Firebase en Android/iOS/Web:
   - android/app/google-services.json
   - ios/Runner/GoogleService-Info.plist
   - web/firebase-messaging-sw.js (si aplica) + config en index.html

3) Inicializa Firebase antes de runApp.

4) Implementa un servicio similar a LocalLeaderboardService usando Firestore.

Colección sugerida: leaderboard_network_master
Documento:
  name: string
  score: number
  stars: number
  millis: number
  ts: number (server timestamp o client)

Luego en UI muestras TOP 50 ordenando por score desc, stars desc, millis asc.
*/
