# Servidor de asignación de profesores (SWI-Prolog)

## Datos del equipo

- **Integrante(s):** [Nombre completo]
- **Matrícula:** [Matrícula]
- **Materia:** Programación avanzada (IA)
- **Profesor:** [Nombre del profesor]
- **Facultad:** Facultad de Ciencias de la Información, UNACAR

## Descripción de la actividad

Servidor web en SWI-Prolog que asigna profesores a academias, cuerpos
académicos, proyectos, cursos y cursos de capacitación, de acuerdo con su
perfil de estudios y capacitación. También permite buscar un profesor y ver
todas sus asignaciones.

## Archivos

| Archivo | Descripción |
| ------- | ----------- |
| `servidor_profesores.pl` | Base de conocimiento, reglas de asignación y servidor HTTP |

## Cómo ejecutarlo

1. Instalar SWI-Prolog (https://www.swi-prolog.org/download/stable).
2. Abrir SWI-Prolog y usar **File → Consult...** para cargar `servidor_profesores.pl`,
   o ejecutar en la consola: `swipl -s servidor_profesores.pl`
3. Abrir en el navegador: http://localhost:8080/home
4. Para detener el servidor: `http_stop_server(8080, []).` y luego `halt.`

## Endpoints

| # | Requisito | Endpoint |
| - | --------- | -------- |
| 1 | Asignar profesores a academias | `/api/academias/asignar?id=a1` |
| 2 | Asignar profesores a cuerpos académicos | `/api/cuerpos/asignar?id=ca1` |
| 3 | Asignar profesores a proyectos | `/api/proyectos/asignar?id=pr1` |
| 4 | Asignar el mejor profesor a un curso | `/api/cursos/asignar?id=c_ia` |
| 5 | Asignar profesores a cursos de capacitación | `/api/capacitaciones/asignar?id=cc4` |
| 6 | Buscar un profesor y sus asignaciones | `/api/profesor?nombre=Ana` o `/api/profesor?id=1001` |

Endpoints de apoyo:

- `/api/profesores`: lista de profesores.
- `/api/sugerir?tipo=academia&id=a1`: ranking de candidatos sin asignar.
- `/api/asignaciones`: todas las asignaciones hechas.

Parámetros opcionales en los endpoints de asignar:

- `profesor=EMPLEADO`: asigna a un profesor en específico.
- `umbral=N`: puntaje mínimo para asignar (por defecto 3).
- `maximo=N`: máximo de profesores a asignar (por defecto 3).

## Cómo se calcula el perfil

Cada entidad (academia, cuerpo académico, proyecto, curso, capacitación)
tiene temas asociados. Para cada tema, el profesor suma:

- 3 puntos si el tema está en su especialidad.
- 2 puntos si lo estudió (licenciatura, maestría o doctorado).
- 1 punto por una capacitación tomada relacionada.
- 1 punto por una acreditación relacionada.

Se toma el mayor valor por tema y se suman. Después se agrega un bono por
grado académico (doctorado +2, maestría +1, licenciatura 0). En los cursos
también cuenta la posición del curso en la lista de cursos que domina el
profesor. Si no hay coincidencia, el puntaje es 0 y no se asigna.

## Entregables negociados con el cliente

> Propuesta a confirmar con el profesor.

| Entregable | Estado |
| ---------- | ------ |
| Servidor en SWI-Prolog con los 6 endpoints solicitados | Entregado |
| Base de conocimiento de ejemplo (profesores, estudios, acreditaciones, academias, cuerpos académicos, proyectos, cursos y capacitaciones) | Entregado |
| Regla de puntaje de perfil (especialidad, estudios, capacitación, acreditación y grado) | Entregado |
| Este `readme.md` con instrucciones de uso | Entregado |

Puntos pendientes de definir con el cliente:

- Si el líder de un proyecto cuenta como integrante.
- Si deben evitarse capacitaciones con fechas traslapadas para un mismo profesor.
- Si las asignaciones deben guardarse en un archivo al reiniciar el servidor
  (hoy se pierden al detenerlo).
- Los pesos del puntaje y los datos de ejemplo.

## Limitaciones

- Las asignaciones se guardan solo en memoria, por lo que se pierden al reiniciar.
- Los datos son de ejemplo y deben sustituirse por los reales de la facultad.
