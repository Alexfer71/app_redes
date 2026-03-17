final List<Map<String, dynamic>> quizLevels = [
  {
    "title": "🚨 ATAQUE DETECTADO",
    "text": "Están intentando entrar a tu red desde Internet. ¿Qué acción te protege mejor?",
    "correct": "Activar el firewall",
    "options": [
      "Activar el firewall",
      "Usar un repetidor",
      "No hacer nada",
      "Cambiar el AP",
    ],
    "explanation": "El firewall filtra y bloquea tráfico malicioso entrante/saliente."
  },
  {
    "title": "🔓 WIFI INSEGURO",
    "text": "Tu Wi‑Fi es fácil de hackear porque usa seguridad antigua. ¿Qué haces?",
    "correct": "Cambiar a WPA3",
    "options": [
      "Cambiar a WPA3",
      "Quitar la contraseña",
      "Abrir la red",
      "Dejarla igual",
    ],
    "explanation": "WPA3 mejora el cifrado y dificulta ataques de fuerza bruta."
  },
  {
    "title": "📡 TRÁFICO SOSPECHOSO",
    "text": "Ves datos raros circulando en la red. ¿Qué herramienta ayuda a detectarlo?",
    "correct": "Instalar IDS",
    "options": [
      "Instalar IDS",
      "Ignorarlo",
      "Cambiar cables",
      "Reiniciar la PC",
    ],
    "explanation": "Un IDS monitorea y alerta sobre patrones sospechosos."
  },
  {
    "title": "🌐 WIFI PÚBLICO",
    "text": "Trabajas desde una red pública. ¿Cómo proteges tu información?",
    "correct": "Usar VPN",
    "options": [
      "Usar VPN",
      "Bluetooth",
      "Wi‑Fi abierto",
      "Nada",
    ],
    "explanation": "Una VPN cifra tu tráfico y reduce el riesgo en redes públicas."
  },
];

final List<Map<String, dynamic>> trueFalseQuestions = [
  {"question": "Zigbee consume menos energía que Wi‑Fi.", "answer": true},
  {"question": "Bluetooth es una red de área amplia.", "answer": false},
];

final List<Map<String, String>> matchConcepts = [
  {"Zigbee": "Bajo consumo"},
  {"Wi‑Fi": "Alta velocidad"},
  {"Bluetooth": "Red personal"},
];
