# RayNote

Un bloc de notas de escritorio escrito en [raylang](https://raylang.dev) que ejercita
las características de ventana nativa de `std/ui` llegadas en **raylang 1.23**
(M255–M259). Es el banco de pruebas de esa superficie: cada menú y cada diálogo de la
app usa una función nueva.

| Característica | Dónde se ve en RayNote |
|---|---|
| **M255** roles estándar de edición y `ui.edit_menu` | El menú Edit está rehecho: Undo/Redo/Cut/Copy/Paste/Select All son `role:*` (funcionan en nativo, sin evento) y entre ellos van *Uppercase Selection*, *Insert Date* y *Document Statistics…* |
| **M257** `set_title`, `set_edited` | El título es `nombre • — RayNote`; en macOS el botón de cerrar muestra el punto de modificado |
| **M257** `intercept_close`, `intercept_quit` | Cerrar la ventana o pulsar ⌘Q con cambios pregunta "Save changes?" (Save / Don't Save / Cancel) |
| **M258** `ui.message`, `message_styled`, `alert` | La pregunta de guardar, los errores de lectura/escritura (estilo `error`) y *Document Statistics…* |
| **M258** diálogos con opciones | *Open…* y *Save As…* llevan título, filtros (Text, Ray sources, All) y nombre sugerido; *Open Several…* usa `pick_files` (selección múltiple) |
| **M259** `ui.popup_menu` | Clic derecho en el editor: menú contextual nativo con roles y items propios |

## Arquitectura

Una ventana nativa (webview del sistema) carga `assets/index.html` por el esquema
`ray://app/…` (sin servidor HTTP). La página manda `edit:<texto>` en cada cambio y
`ctx` en el clic derecho por el puente IPC; cuando el programa cambia el documento
(abrir, nuevo) le pide a la página que lo **recupere** con `window.ray.request("get")`,
que raylang resuelve con `ui.reply` — así ningún texto necesita escaparse a mano en
JavaScript. El estado vive en la fibra del bucle de eventos (`src/main.ray`); el modelo
puro está en `src/doc.ray` y se prueba en `tests/`.

## Uso

```sh
ray run          # VM (raylang >= 1.27.13)
ray dev          # con recarga en vivo
ray test         # tests del modelo
ray build --native --release   # binario nativo ./raynote
make smoke       # arranque headless (CI, sin display)
```

Bajo `ray run` en macOS el menú de la aplicación se llama como el proceso ("ray");
`ui.app_menu("RayNote", …)` lo renombra. Un `.app` de `ray bundle` ya trae su nombre.
