# Entregable Dia 1 - Introduccion al Desarrollo Backend
---

## 1. Que es una API?

Es basicamente un intermediario entre dos sistemas. Uno le pide algo, el otro responde, y ninguno necesita saber como funciona el otro por dentro.
---

## 2. Los 6 Principios REST

| Principio | Que entendi | Ejemplo que vi |
|-----------|-------------|----------------|
| Cliente-Servidor | El frontend y backend son independientes, solo hablan por HTTP | Insomnia y JSONPlaceholder no saben nada el uno del otro |
| Sin Estado | Cada request trae todo lo que necesita, el servidor no recuerda nada | `GET /posts/1` funciona solo, no necesitas haber llamado nada antes |
| Cacheable | Las respuestas dicen si se pueden guardar y por cuanto tiempo | JSONPlaceholder responde con `Cache-Control: max-age=14400` (4 horas) |
| Sistema en Capas | El cliente no sabe si hay un proxy o load balancer en medio | JSONPlaceholder pasa por Cloudflare y uno ni lo nota |
| Interfaz Uniforme | Todos los recursos siguen el mismo patron de URLs y metodos | `/posts`, `/posts/1`, `/posts/1/comments` — siempre consistente |
| Codigo bajo demanda | El servidor puede mandar codigo ejecutable al cliente (opcional) | No lo vi en estas APIs, aplica mas en apps web con JS dinamico |

---

## 3. Metodos HTTP

### GET
- Cuando: cuando solo quiero leer algo, sin modificar nada
- Ejemplo tienda: `GET /productos/42` para ver el detalle de un producto

### POST
- Cuando: para crear algo nuevo
- Ejemplo tienda: `POST /pedidos` con los datos del carrito para hacer una orden

### PUT
- Cuando: para reemplazar un recurso completo
- Ejemplo tienda: `PUT /productos/42` mandando todos los campos del producto aunque solo cambie uno

### PATCH
- Cuando: para cambiar solo un campo sin mandar todo el objeto
- Ejemplo tienda: `PATCH /productos/42` con solo `{"precio": 299.99}`

### DELETE
- Cuando: para eliminar algo
- Ejemplo tienda: `DELETE /carrito/items/7` para quitar un producto del carrito

---

## 4. Resultados Ejercicio 1 - JSONPlaceholder

### Endpoint 1
- URL: `GET /posts`
- Codigo: 200 OK
- Respuesta: Array de 100 posts. Cada uno tiene `userId`, `id`, `title`, `body`

### Endpoint 2
- URL: `GET /posts/1`
- Codigo: 200 OK
- Respuesta: El mismo objeto pero uno solo, no array

### Endpoint 3
- URL: `GET /posts/1/comments`
- Codigo: 200 OK
- Respuesta: Array de 5 comentarios con `postId`, `id`, `name`, `email`, `body`

### Endpoint 4
- URL: `GET /users/1`
- Codigo: 200 OK
- Respuesta: Usuario con objetos anidados — `address` tiene dentro otro objeto `geo` con `lat` y `lng`

### Endpoint 5
- URL: `GET /posts/99999`
- Codigo: 404 Not Found
- Respuesta: `{}` — body vacio, el post no existe

---

## 5. Resultados Ejercicio 2 - PokeAPI

### Tabla Comparativa

| Campo | Bulbasaur | Charmander | Squirtle |
|-------|-----------|------------|----------|
| ID | 1 | 4 | 7 |
| Tipo(s) | grass / poison | fire | water |
| HP | 45 | 39 | 44 |
| Ataque | 49 | 52 | 48 |
| Velocidad | 45 | 65 | 43 |
| Experiencia base | 64 | 62 | 63 |

### Analisis
Charmander es el mas rapido por mucho (65 de velocidad). Los tres tienen experiencia base muy parecida, claramente estan balanceados a proposito. Lo interesante de la API es que `types` es un array de objetos donde cada uno tiene otro objeto `type` adentro con `name` y `url` — HATEOAS en accion, puedes seguir esa URL para obtener mas info del tipo.

---

## 6. Resultados Ejercicio 3 - CRUD

| Metodo | URL | Codigo | Body recibido |
|--------|-----|--------|---------------|
| GET | /posts/1 | 200 OK | Objeto completo del post |
| POST | /posts | 201 Created | El objeto enviado + `id: 101` asignado |
| PUT | /posts/1 | 200 OK | Exactamente lo que mande |
| PATCH | /posts/1 | 200 OK | Solo cambio el title, los demas campos quedaron igual |
| DELETE | /posts/1 | 200 OK | `{}` vacio |

### Diferencias entre PUT y PATCH
PUT reemplaza todo — si no mandas un campo, se pierde. PATCH solo toca lo que le mandas, el resto queda intacto. En el ejercicio se vio clarito: con PATCH mande solo `{"title": "..."}` y `body` y `userId` seguian ahi.

### Que paso con DELETE?
Devolvio 200 con `{}`. Esperaba 204 sin body, que es lo mas comun. JSONPlaceholder usa 200 probablemente por simplicidad.

---

## 7. Analisis de Headers

### Headers interesantes:

1. `Cache-Control: max-age=14400` — la respuesta se puede cachear 4 horas. Un proxy no necesita ir al servidor durante ese tiempo.

2. `Access-Control-Allow-Origin: *` — cualquier dominio puede hacer requests desde el browser. En una API privada esto estaria restringido a dominios especificos.

3. `X-Ratelimit-Remaining` (PokeAPI) — dice cuantas peticiones te quedan antes de recibir un 429. Es un header personalizado que implementan para controlar el abuso.

### Reflexion sobre 404:
`GET /posts/99999` — la ruta existe, el recurso no. Problema en los datos.
`GET /ruta-inventada` — el servidor no conoce esa ruta. Problema en el enrutamiento.
Mismo codigo, diferente causa. En produccion deberias distinguirlos en el body del error.

---