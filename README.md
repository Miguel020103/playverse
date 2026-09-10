# PLAYVERSE — Foundation + Core UI

**Your sport. Your teams. Your arena.**

## Incluye

- Onboarding profesional (barra de progreso, segundo equipo claro)
- Bloqueo de vuelta al onboarding tras completarlo
- Bottom nav: Inicio · Divisiones · Calendario · Más
- Divisiones AFC/NFC con 32 equipos
- Calendario (estructura)
- Vestuario del equipo (paleta fija)
- Más: tema, cambiar equipos, reiniciar, placeholders Learn / Logros / MY ARENA
- Hive + Riverpod + GoRouter

## Uso

1. Copia `lib/` y `pubspec.yaml` sobre tu proyecto
2. Mantén tus `assets/images/teams/...` en PNG
3. `flutter pub get && flutter run`

## Navegación

| Tab | Contenido |
|-----|-----------|
| Inicio | Resumen, accesos rápidos, tus equipos |
| Divisiones | Conferencias y divisiones NFL |
| Calendario | Partidos (placeholder → datos reales después) |
| Más | Ajustes, equipos, próximos módulos |

## Siguiente fase

- Partidos programados + registro de resultados
- Standings calculados
- Logros y Learn
