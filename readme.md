# Servidor de asignación de profesores (SWI-Prolog)

## Datos del equipo

- **Integrante(s):** [ALEJANDRO DEL JESUS DIAZ LOPEZ]
- **Matrícula:** [191087]
- **Materia:** Programación avanzada
- **Profesor:** [Jesús Alejandro Flores Hernández]
- **Facultad:** Facultad de Ciencias de la Información, UNACAR

## Descripción de la actividad

Servidor web en SWI-Prolog que asigna profesores a academias, cuerpos
académicos, proyectos, comisiones, cursos a impartir y cursos de capacitación,
de acuerdo con su perfil de estudios y capacitación. Permite buscar un
profesor y ver sus asignaciones, y llevar el control de sus estudios
(licenciatura, maestría y doctorado), acreditaciones y capacitaciones tomadas.

Está hecho con el mismo estilo del ejemplo `serverPersonas.pl` del material
de clase (`codigos/prolog/swiprolog/server`): base de conocimiento con hechos y
reglas, `http_handler`, `http_parameters`, `reply_json_dict` con diccionarios
y `reply_html_page`.

## Archivos

| Archivo | Descripción |
| ------- | ----------- |
| `servidor_profesores.pl` | Base de conocimiento, reglas de asignación y servidor HTTP |
| `readme.md` | Este documento |

## Cómo ejecutarlo

1. Instalar SWI-Prolog (https://www.swi-prolog.org/download/stable).
2. Abrir SWI-Prolog y usar **File → Consult...** para cargar `servidor_profesores.pl`,
   o ejecutar en la terminal: `swipl -s servidor_profesores.pl`
3. Abrir en el navegador: http://localhost:8080/home
4. Para detener el servidor, en la consola: `http_stop_server(8080, []).` y luego `halt.`

## Endpoints

### Opciones solicitadas

| # | Requisito | Endpoint |
| - | --------- | -------- |
| 1 | Asignar profesores a academias | `/api/academias/asignar?id=a1` |
| 2 | Asignar profesores a cuerpos académicos | `/api/cuerpos/asignar?id=ca1` |
| 3 | Asignar profesores a proyectos | `/api/proyectos/asignar?id=pr1` |
| 4 | Asignar el mejor profesor a un curso | `/api/cursos/asignar?id=c_ia` |
| 5 | Asignar profesores a cursos de capacitación | `/api/capacitaciones/asignar?id=cc4` |
| 6 | Buscar un profesor y sus asignaciones | `/api/profesor?nombre=Ana` o `/api/empleado?id=1001` |
| — | Asignar profesores a comisiones | `/api/comisiones/asignar?id=co1` |

### Control de estudios, acreditaciones y capacitaciones

| Acción | Endpoint |
| ------ | -------- |
| Registrar un estudio | `/api/estudios/registrar?empleado=1001&nivel=maestria&titulo=Maestria%20en%20Web&area=web` |
| Registrar una acreditación | `/api/acreditaciones/registrar?empleado=1001&nombre=Certificacion&tema=web` |
| Registrar una capacitación tomada | `/api/capacitaciones/tomada?empleado=1001&id=cc1` |

Los niveles válidos son `licenciatura`, `maestria` y `doctorado`.

### Consultas

- `/api/profesores`, `/api/academias`, `/api/cuerpos`, `/api/proyectos`,
  `/api/comisiones`, `/api/cursos`, `/api/capacitaciones`
- `/api/sugerir?tipo=academia&id=a1`: ranking de candidatos sin asignar.
  Los tipos son `academia`, `cuerpo`, `proyecto`, `comision`, `curso` y `capacitacion`.
- `/api/asignaciones`: todas las asignaciones hechas.
- `/html/profesores`: vista HTML de los profesores.

## Cómo se calcula el perfil

Cada entidad (academia, cuerpo académico, proyecto, comisión, curso, capacitación)
tiene temas asociados. Para cada tema, el profesor suma el mayor de estos valores:

- 3 puntos si el tema está en su especialidad.
- 2 puntos si lo estudió (licenciatura, maestría o doctorado).
- 1 punto por una capacitación tomada relacionada.
- 1 punto por una acreditación relacionada.

Después se suma un bono por grado académico (doctorado +2, maestría +1,
licenciatura 0). Para los cursos también cuenta la posición del curso en la
lista de cursos que domina el profesor (más arriba, más puntos).

Reglas de asignación: se necesita un puntaje mínimo de 3 y se asignan como
máximo 3 profesores. Un curso a impartir lleva solo al mejor. No se repite a un
profesor ya asignado, ni se le asigna una capacitación que ya tomó.

## Entregables negociados con el cliente

> Propuesta a confirmar con el profesor.

| Entregable | Estado |
| ---------- | ------ |
| Servidor en SWI-Prolog con las 6 opciones solicitadas, más comisiones | Entregado |
| Control de estudios, acreditaciones y capacitaciones tomadas | Entregado |
| Base de conocimiento de ejemplo (profesores, academias, cuerpos académicos, proyectos, comisiones, cursos y capacitaciones) | Entregado |
| Regla de puntaje de perfil (especialidad, estudios, capacitación, acreditación y grado) | Entregado |
| Este `readme.md` con instrucciones de uso | Entregado |

Puntos pendientes de definir con el cliente:

- Los campos de las comisiones, porque el enunciado no los define.
- Si el líder de un proyecto cuenta como integrante.
- Si deben evitarse capacitaciones con fechas traslapadas para un mismo profesor.
- Si las asignaciones deben guardarse en un archivo al reiniciar el servidor.
- Los pesos del puntaje y los datos de ejemplo.

## Notas

- Las asignaciones y los registros nuevos se guardan en memoria (`assertz`), por
  lo que se pierden al detener el servidor.
- Los datos son de ejemplo y deben sustituirse por los reales de la facultad.
- Se probó con SWI-Prolog 9.0.4 en Linux; los endpoints respondieron
  correctamente.
