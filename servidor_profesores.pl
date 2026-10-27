% Servidor SWI-Prolog: asignacion de profesores - Facultad de Ciencias de la Informacion, UNACAR
% Base de conocimiento + servidor web que expone una API REST (mismo estilo que serverPersonas.pl).
% Para ejecutar este servidor:
% ejecutar: swipl -s servidor_profesores.pl
% (o en la consola: menu/file/consult/ elije el archivo/enter)
% mostrara una consola con el servidor corriendo en el puerto 8080
% abrir: http://localhost:8080/home
% detener el servidor, desde la consola abierta: http_stop_server(8080, []).
% en la consola poner: halt.
%

% ================================================
% Base de conocimiento
% ================================================

% Datos que cambian cuando se usa el sistema (asignaciones y control de estudios)
:- dynamic asignacion/3.            % asignacion(Tipo, IdEntidad, Empleado)
:- dynamic estudio/4.               % estudio(Empleado, Nivel, Titulo, Area)
:- dynamic acreditacion/3.          % acreditacion(Empleado, Nombre, Tema)
:- dynamic capacitacion_tomada/2.   % capacitacion_tomada(Empleado, IdCapacitacion)

% profesor(Empleado, Nombre, Grado, CursosQueDomina) - cursos de mayor a menor dominio
profesor('1001', 'Ana Lopez Reyes',    doctorado,    [c_ia, c_prolog, c_algoritmos]).
profesor('1002', 'Carlos Mendez Cruz', maestria,     [c_bd, c_isw, c_web]).
profesor('1003', 'Laura Perez Gil',    doctorado,    [c_algoritmos, c_ia, c_paralela]).
profesor('1004', 'Jorge Ramos Diaz',   maestria,     [c_paralela, c_web, c_prolog]).
profesor('1005', 'Marta Silva Ortiz',  licenciatura, [c_web, c_isw, c_bd]).

% especialidad(Empleado, Tema)
especialidad('1001', inteligencia_artificial).
especialidad('1001', sistemas_expertos).
especialidad('1002', bases_de_datos).
especialidad('1002', ingenieria_software).
especialidad('1003', redes_neuronales).
especialidad('1003', algoritmos).
especialidad('1004', programacion).
especialidad('1004', paralelo).
especialidad('1005', web).
especialidad('1005', ingenieria_software).

% estudio(Empleado, Nivel, Titulo, Area)
estudio('1001', licenciatura, 'Ing. en Sistemas',              programacion).
estudio('1001', maestria,     'Maestria en Computacion',       inteligencia_artificial).
estudio('1001', doctorado,    'Doctorado en IA',               sistemas_expertos).
estudio('1002', licenciatura, 'Ing. en Sistemas',              programacion).
estudio('1002', maestria,     'Maestria en Bases de Datos',    bases_de_datos).
estudio('1003', licenciatura, 'Ing. en Computacion',           algoritmos).
estudio('1003', maestria,     'Maestria en Computacion',       algoritmos).
estudio('1003', doctorado,    'Doctorado en Redes Neuronales', redes_neuronales).
estudio('1004', licenciatura, 'Ing. en Sistemas',              programacion).
estudio('1004', maestria,     'Maestria en Computo Paralelo',  paralelo).
estudio('1005', licenciatura, 'Lic. en Informatica',           web).

% acreditacion(Empleado, Nombre, Tema)
acreditacion('1001', 'Certificacion en Prolog',         sistemas_expertos).
acreditacion('1002', 'Certificacion en SQL',            bases_de_datos).
acreditacion('1004', 'Certificacion en Concurrencia',   paralelo).
acreditacion('1005', 'Certificacion en Desarrollo Web', web).

% capacitacion_tomada(Empleado, IdCapacitacion)
capacitacion_tomada('1001', cc2).
capacitacion_tomada('1002', cc3).
capacitacion_tomada('1004', cc1).

% academia(Id, Nombre, MateriasAsignadas, Lider)
academia(a1, 'Academia de Inteligencia Artificial',   [c_ia, c_prolog],           '1001').
academia(a2, 'Academia de Ingenieria de Software',    [c_isw, c_web, c_bd],       '1002').
academia(a3, 'Academia de Algoritmos y Paralelismo',  [c_algoritmos, c_paralela], '1003').

% cuerpo_academico(Id, Nombre, LineaInvestigacion, Lider, Estatus)
cuerpo_academico(ca1, 'Computacion Inteligente', 'Aprendizaje automatico',         '1003', consolidado).
cuerpo_academico(ca2, 'Sistemas de Informacion', 'Ingenieria de software y datos', '1002', en_consolidacion).

% proyecto(Id, Nombre, Objetivo, Entregables, Lider, FechaInicio, FechaEntrega)
% los integrantes son los profesores asignados al proyecto
proyecto(pr1, 'Sistema experto de diagnostico', 'Apoyar el diagnostico de fallas',
         [base_de_conocimiento, motor_de_inferencia, interfaz], '1001', '2026-02-01', '2026-11-30').
proyecto(pr2, 'Portal academico web', 'Publicar informacion de cursos y profesores',
         [prototipo, portal, manual], '1005', '2026-03-01', '2026-12-15').

% comision(Id, Nombre, Objetivo, Lider)
comision(co1, 'Comision de evaluacion curricular', 'Revisar los planes de estudio',    '1002').
comision(co2, 'Comision de investigacion',         'Coordinar la investigacion de la facultad', '1003').

% curso(Id, Creditos, Nombre, Objetivo, Academia)
curso(c_ia,         5, 'Inteligencia Artificial', 'Conocer tecnicas de IA',         a1).
curso(c_prolog,     4, 'Programacion en Prolog',  'Programar con logica',           a1).
curso(c_isw,        5, 'Ingenieria de Software',  'Aplicar procesos de software',   a2).
curso(c_web,        4, 'Programacion Web',        'Construir aplicaciones web',     a2).
curso(c_bd,         5, 'Bases de Datos',          'Disenar bases de datos',         a2).
curso(c_algoritmos, 5, 'Algoritmos',              'Analizar y disenar algoritmos',  a3).
curso(c_paralela,   4, 'Programacion Paralela',   'Programar de forma concurrente', a3).

% curso_capacitacion(Id, Nombre, Objetivo, Horas, FechaInicio, FechaConclusion)
curso_capacitacion(cc1, 'Taller de concurrencia',     'Practicar concurrencia',    20, '2026-11-02', '2026-11-06').
curso_capacitacion(cc2, 'Taller de Prolog avanzado',  'Profundizar en Prolog',     20, '2026-11-09', '2026-11-13').
curso_capacitacion(cc3, 'Curso de SQL avanzado',      'Optimizar consultas',       30, '2026-11-16', '2026-11-27').
curso_capacitacion(cc4, 'Redes neuronales aplicadas', 'Aplicar redes neuronales',  40, '2026-12-01', '2026-12-11').

% tema(Tipo, Id, Tema): temas que requiere cada entidad (se comparan con el perfil del profesor)
tema(academia, a1, inteligencia_artificial).
tema(academia, a1, sistemas_expertos).
tema(academia, a2, ingenieria_software).
tema(academia, a2, web).
tema(academia, a2, bases_de_datos).
tema(academia, a3, algoritmos).
tema(academia, a3, paralelo).

tema(cuerpo, ca1, inteligencia_artificial).
tema(cuerpo, ca1, redes_neuronales).
tema(cuerpo, ca2, ingenieria_software).
tema(cuerpo, ca2, bases_de_datos).

tema(proyecto, pr1, sistemas_expertos).
tema(proyecto, pr1, programacion).
tema(proyecto, pr2, web).
tema(proyecto, pr2, ingenieria_software).

tema(comision, co1, ingenieria_software).
tema(comision, co1, programacion).
tema(comision, co2, inteligencia_artificial).
tema(comision, co2, algoritmos).

tema(curso, c_ia,         inteligencia_artificial).
tema(curso, c_prolog,     sistemas_expertos).
tema(curso, c_prolog,     programacion).
tema(curso, c_isw,        ingenieria_software).
tema(curso, c_web,        web).
tema(curso, c_bd,         bases_de_datos).
tema(curso, c_algoritmos, algoritmos).
tema(curso, c_paralela,   paralelo).

tema(capacitacion, cc1, paralelo).
tema(capacitacion, cc2, sistemas_expertos).
tema(capacitacion, cc3, bases_de_datos).
tema(capacitacion, cc4, redes_neuronales).
tema(capacitacion, cc4, inteligencia_artificial).

% ================================================
% Reglas
% ================================================

% entidad(Tipo, Id, Nombre)
entidad(academia,     Id, N) :- academia(Id, N, _, _).
entidad(cuerpo,       Id, N) :- cuerpo_academico(Id, N, _, _, _).
entidad(proyecto,     Id, N) :- proyecto(Id, N, _, _, _, _, _).
entidad(comision,     Id, N) :- comision(Id, N, _, _).
entidad(curso,        Id, N) :- curso(Id, _, N, _, _).
entidad(capacitacion, Id, N) :- curso_capacitacion(Id, N, _, _, _, _).

% Puntos que aporta un profesor a un tema segun su perfil
peso(P, T, 3) :- especialidad(P, T).                                % especialidad
peso(P, T, 2) :- estudio(P, _, _, T).                               % estudios
peso(P, T, 1) :- capacitacion_tomada(P, C), tema(capacitacion, C, T). % capacitacion tomada
peso(P, T, 1) :- acreditacion(P, _, T).                             % acreditacion

% Bono por grado academico
bono(doctorado, 2).
bono(maestria, 1).
bono(licenciatura, 0).

% Reglas de asignacion
umbral(3).               % puntaje minimo para asignar
maximo_asignados(3).     % profesores que se asignan como maximo
limite(curso, 1) :- !.   % un curso a impartir lleva solo al mejor profesor
limite(_, M) :- maximo_asignados(M).

% Auxiliares de listas
suma([], 0).
suma([X|R], S) :- suma(R, S0), S is S0 + X.

mayor([X], X).
mayor([X|R], M) :- R \= [], mayor(R, M0), ( X > M0 -> M = X ; M = M0 ).

posicion(X, [X|_], 1).
posicion(X, [_|R], K) :- posicion(X, R, K0), K is K0 + 1.

primeros(0, _, []) :- !.
primeros(_, [], []) :- !.
primeros(N, [X|R], [X|Rs]) :- N1 is N - 1, primeros(N1, R, Rs).

% mejor puntaje de un profesor en un tema (si no tiene ninguno, falla)
mejor_peso(P, T, M) :-
    findall(W, peso(P, T, W), Ws),
    Ws \= [],
    mayor(Ws, M).

% puntos por dominar el curso (solo cuando se asigna un curso): mientras mas arriba en su lista, mas puntos
dominio(P, curso, Id, S) :-
    profesor(P, _, _, Cursos),
    posicion(Id, Cursos, K), !,
    length(Cursos, N),
    S is 10 + N - K + 1.
dominio(_, _, _, 0).

% puntaje(Profesor, Tipo, Id, Puntaje): 0 si no tiene nada en comun con la entidad
puntaje(P, Tipo, Id, Puntaje) :-
    profesor(P, _, Grado, _),
    findall(M, ( tema(Tipo, Id, T), mejor_peso(P, T, M) ), Ms),
    suma(Ms, S1),
    dominio(P, Tipo, Id, S2),
    S0 is S1 + S2,
    (   S0 > 0
    ->  bono(Grado, B), Puntaje is S0 + B
    ;   Puntaje = 0
    ).

% ranking(Tipo, Id, Lista): pares PuntajeNegativo-Profesor ordenados del mejor al peor
ranking(Tipo, Id, Rank) :-
    findall(NP-P,
            ( profesor(P, _, _, _), puntaje(P, Tipo, Id, S), S > 0, NP is -S ),
            L),
    keysort(L, Rank).

% candidatos: los del ranking que cumplen el umbral y no estan asignados ni ya tomaron el curso
candidatos(Tipo, Id, Rank) :-
    umbral(U),
    findall(NP-P,
            ( profesor(P, _, _, _),
              \+ asignacion(Tipo, Id, P),
              \+ ( Tipo = capacitacion, capacitacion_tomada(P, Id) ),
              puntaje(P, Tipo, Id, S),
              S >= U,
              NP is -S ),
            L),
    keysort(L, Rank).

% asignar_mejores(Tipo, Id, Resultado)
asignar_mejores(curso, Id, _{mensaje: 'El curso ya tiene profesor asignado', profesor: P}) :-
    asignacion(curso, Id, P), !.
asignar_mejores(Tipo, Id, Res) :-
    candidatos(Tipo, Id, Rank),
    limite(Tipo, M),
    primeros(M, Rank, Top),
    registrar(Tipo, Id, Top, Asignados),
    (   Asignados = []
    ->  Res = _{mensaje: 'Ningun profesor tiene el perfil suficiente', asignados: []}
    ;   Res = _{asignados: Asignados}
    ).

registrar(_, _, [], []).
registrar(Tipo, Id, [NP-P|R], [_{empleado: P, nombre: N, puntaje: S}|Rs]) :-
    assertz(asignacion(Tipo, Id, P)),
    profesor(P, N, _, _),
    S is -NP,
    registrar(Tipo, Id, R, Rs).

% datos completos de un profesor, con sus asignaciones (opcion 6)
profesor_dict(P, _{empleado: P, nombre: N, grado: G, especialidades: Es, cursos_que_domina: Cs,
                   estudios: Est, acreditaciones: Ac, capacitaciones_tomadas: Ca, asignaciones: As}) :-
    profesor(P, N, G, Cs),
    findall(T, especialidad(P, T), Es),
    findall(_{nivel: Ni, titulo: Ti, area: Ar}, estudio(P, Ni, Ti, Ar), Est),
    findall(_{nombre: An, tema: At}, acreditacion(P, An, At), Ac),
    findall(_{id: Ci, nombre: Cn},
            ( capacitacion_tomada(P, Ci), curso_capacitacion(Ci, Cn, _, _, _, _) ),
            Ca),
    findall(_{tipo: Tipo, id: Id, nombre: En},
            ( asignacion(Tipo, Id, P), entidad(Tipo, Id, En) ),
            As).

% ================================================
% server
% ================================================

:- use_module(library(http/http_server)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/html_write)).

% Inicializar el servidor
:- initialization http_server([port(8080)]).

% Definir los manejadores de rutas
:- http_handler(root(.), home_page, []).
:- http_handler(root(home), home_page, []).
:- http_handler(root(api/profesores), api_profesores, []).
:- http_handler(root(api/profesor), api_profesor, []).
:- http_handler(root(api/empleado), api_empleado, []).
:- http_handler(root(api/academias), api_academias, []).
:- http_handler(root(api/cuerpos), api_cuerpos, []).
:- http_handler(root(api/proyectos), api_proyectos, []).
:- http_handler(root(api/comisiones), api_comisiones, []).
:- http_handler(root(api/cursos), api_cursos, []).
:- http_handler(root(api/capacitaciones), api_capacitaciones, []).
:- http_handler(root(api/sugerir), api_sugerir, []).
:- http_handler(root(api/asignaciones), api_asignaciones, []).
:- http_handler(root(api/academias/asignar), api_asignar_academia, []).
:- http_handler(root(api/cuerpos/asignar), api_asignar_cuerpo, []).
:- http_handler(root(api/proyectos/asignar), api_asignar_proyecto, []).
:- http_handler(root(api/comisiones/asignar), api_asignar_comision, []).
:- http_handler(root(api/cursos/asignar), api_asignar_curso, []).
:- http_handler(root(api/capacitaciones/asignar), api_asignar_capacitacion, []).
:- http_handler(root(api/estudios/registrar), api_registrar_estudio, []).
:- http_handler(root(api/acreditaciones/registrar), api_registrar_acreditacion, []).
:- http_handler(root(api/capacitaciones/tomada), api_registrar_tomada, []).
:- http_handler(root(html/profesores), html_profesores, []).

% ================================================
% RUTA: Pagina de inicio
% ================================================
home_page(_Request) :-
    reply_html_page(
        title('Asignacion de profesores - FCI UNACAR'),
        [
            h1('Asignacion de profesores - FCI UNACAR'),
            p('Servidor con una base de conocimiento de profesores, academias, cuerpos academicos, proyectos, comisiones, cursos y cursos de capacitacion.'),
            h2('Asignar profesores (opciones 1 a 5):'),
            ul([
                li('GET /api/academias/asignar?id=a1 - Asignar profesores a una academia'),
                li('GET /api/cuerpos/asignar?id=ca1 - Asignar profesores a un cuerpo academico'),
                li('GET /api/proyectos/asignar?id=pr1 - Asignar profesores a un proyecto'),
                li('GET /api/comisiones/asignar?id=co1 - Asignar profesores a una comision'),
                li('GET /api/cursos/asignar?id=c_ia - Asignar el mejor profesor a un curso'),
                li('GET /api/capacitaciones/asignar?id=cc4 - Asignar profesores a un curso de capacitacion')
            ]),
            h2('Buscar un profesor y sus asignaciones (opcion 6):'),
            ul([
                li('GET /api/profesor?nombre=Ana - Buscar por nombre'),
                li('GET /api/empleado?id=1001 - Buscar por numero de empleado'),
                li('GET /api/profesores - Listar todos los profesores'),
                li('GET /html/profesores - Vista HTML de los profesores'),
                li('GET /api/asignaciones - Ver todas las asignaciones')
            ]),
            h2('Control de estudios y capacitacion:'),
            ul([
                li('GET /api/estudios/registrar?empleado=1001&nivel=maestria&titulo=Maestria&area=web'),
                li('GET /api/acreditaciones/registrar?empleado=1001&nombre=Certificacion&tema=web'),
                li('GET /api/capacitaciones/tomada?empleado=1001&id=cc1')
            ]),
            h2('Consultas:'),
            ul([
                li('GET /api/academias, /api/cuerpos, /api/proyectos, /api/comisiones, /api/cursos, /api/capacitaciones'),
                li('GET /api/sugerir?tipo=academia&id=a1 - Ranking de candidatos sin asignar')
            ])
        ]
    ).

% ================================================
% RUTA: listados
% ================================================
api_profesores(_Request) :-
    findall(_{empleado: P, nombre: N, grado: G}, profesor(P, N, G, _), L),
    reply_json_dict(L).

api_academias(_Request) :-
    findall(_{id: Id, nombre: N, materias: M, lider: L}, academia(Id, N, M, L), R),
    reply_json_dict(R).

api_cuerpos(_Request) :-
    findall(_{id: Id, nombre: N, linea_investigacion: Li, lider: L, estatus: E},
            cuerpo_academico(Id, N, Li, L, E), R),
    reply_json_dict(R).

api_proyectos(_Request) :-
    findall(_{id: Id, nombre: N, objetivo: O, entregables: En, lider: L,
              integrantes: Ints, fecha_inicio: Fi, fecha_entrega: Fe},
            ( proyecto(Id, N, O, En, L, Fi, Fe),
              findall(P, asignacion(proyecto, Id, P), Ints) ),
            R),
    reply_json_dict(R).

api_comisiones(_Request) :-
    findall(_{id: Id, nombre: N, objetivo: O, lider: L}, comision(Id, N, O, L), R),
    reply_json_dict(R).

api_cursos(_Request) :-
    findall(_{id: Id, creditos: C, nombre: N, objetivo: O, academia: A},
            curso(Id, C, N, O, A), R),
    reply_json_dict(R).

api_capacitaciones(_Request) :-
    findall(_{id: Id, nombre: N, objetivo: O, horas: H, fecha_inicio: Fi, fecha_conclusion: Fc},
            curso_capacitacion(Id, N, O, H, Fi, Fc), R),
    reply_json_dict(R).

% ================================================
% RUTA: buscar un profesor y sus asignaciones (opcion 6)
% ================================================
api_profesor(Request) :-
    http_parameters(Request, [
        nombre(Nombre, [])
    ]),
    findall(D,
            ( profesor(P, N, _, _), sub_atom(N, _, _, _, Nombre), profesor_dict(P, D) ),
            Profesores),
    (   Profesores \= []
    ->  reply_json_dict(_{busqueda: Nombre, profesores: Profesores})
    ;   reply_json_dict(_{error: 'Profesor no encontrado'}, [status(404)])
    ).

api_empleado(Request) :-
    http_parameters(Request, [
        id(Id, [])
    ]),
    (   profesor_dict(Id, D)
    ->  reply_json_dict(D)
    ;   reply_json_dict(_{error: 'Profesor no encontrado'}, [status(404)])
    ).

api_asignaciones(_Request) :-
    findall(_{tipo: T, id: I, nombre: N, empleado: P},
            ( asignacion(T, I, P), entidad(T, I, N) ),
            L),
    reply_json_dict(L).

% ================================================
% RUTA: ranking de candidatos (sin asignar)
% ================================================
api_sugerir(Request) :-
    http_parameters(Request, [
        tipo(Tipo, []),
        id(Id, [])
    ]),
    (   entidad(Tipo, Id, Nombre)
    ->  ranking(Tipo, Id, Rank),
        filas_ranking(Rank, Candidatos),
        reply_json_dict(_{tipo: Tipo, id: Id, nombre: Nombre, candidatos: Candidatos})
    ;   reply_json_dict(_{error: 'Entidad no encontrada'}, [status(404)])
    ).

filas_ranking([], []).
filas_ranking([NP-P|R], [_{empleado: P, nombre: N, puntaje: S}|Rs]) :-
    profesor(P, N, _, _),
    S is -NP,
    filas_ranking(R, Rs).

% ================================================
% RUTA: asignar profesores (opciones 1 a 5 y comisiones)
% ================================================
api_asignar_academia(Request)     :- asignar_http(Request, academia).
api_asignar_cuerpo(Request)       :- asignar_http(Request, cuerpo).
api_asignar_proyecto(Request)     :- asignar_http(Request, proyecto).
api_asignar_comision(Request)     :- asignar_http(Request, comision).
api_asignar_curso(Request)        :- asignar_http(Request, curso).
api_asignar_capacitacion(Request) :- asignar_http(Request, capacitacion).

asignar_http(Request, Tipo) :-
    http_parameters(Request, [
        id(Id, [])
    ]),
    (   entidad(Tipo, Id, Nombre)
    ->  asignar_mejores(Tipo, Id, Resultado),
        reply_json_dict(_{tipo: Tipo, id: Id, nombre: Nombre, resultado: Resultado})
    ;   reply_json_dict(_{error: 'Entidad no encontrada'}, [status(404)])
    ).

% ================================================
% RUTA: control de estudios, acreditaciones y capacitaciones tomadas
% ================================================
api_registrar_estudio(Request) :-
    http_parameters(Request, [
        empleado(P, []),
        nivel(Nivel, []),
        titulo(Titulo, []),
        area(Area, [])
    ]),
    (   \+ profesor(P, _, _, _)
    ->  reply_json_dict(_{error: 'Profesor no encontrado'}, [status(404)])
    ;   \+ bono(Nivel, _)
    ->  reply_json_dict(_{error: 'Nivel invalido: licenciatura, maestria o doctorado'}, [status(400)])
    ;   assertz(estudio(P, Nivel, Titulo, Area)),
        reply_json_dict(_{mensaje: 'Estudio registrado', empleado: P, nivel: Nivel, titulo: Titulo, area: Area})
    ).

api_registrar_acreditacion(Request) :-
    http_parameters(Request, [
        empleado(P, []),
        nombre(Nombre, []),
        tema(Tema, [])
    ]),
    (   profesor(P, _, _, _)
    ->  assertz(acreditacion(P, Nombre, Tema)),
        reply_json_dict(_{mensaje: 'Acreditacion registrada', empleado: P, nombre: Nombre, tema: Tema})
    ;   reply_json_dict(_{error: 'Profesor no encontrado'}, [status(404)])
    ).

api_registrar_tomada(Request) :-
    http_parameters(Request, [
        empleado(P, []),
        id(C, [])
    ]),
    (   \+ profesor(P, _, _, _)
    ->  reply_json_dict(_{error: 'Profesor no encontrado'}, [status(404)])
    ;   \+ curso_capacitacion(C, _, _, _, _, _)
    ->  reply_json_dict(_{error: 'Curso de capacitacion no encontrado'}, [status(404)])
    ;   capacitacion_tomada(P, C)
    ->  reply_json_dict(_{error: 'El profesor ya tenia registrado ese curso'}, [status(400)])
    ;   assertz(capacitacion_tomada(P, C)),
        reply_json_dict(_{mensaje: 'Capacitacion registrada', empleado: P, id: C})
    ).

% ================================================
% RUTA: Vista HTML de todos los profesores
% ================================================
html_profesores(_Request) :-
    findall(profesor(P, N, G), profesor(P, N, G, _), Profesores),
    reply_html_page(
        title('Lista de Profesores'),
        [
            h1('Profesores Registrados'),
            table(
                [
                    tr([th('Empleado'), th('Nombre'), th('Grado')]),
                    \profesores_filas(Profesores)  % <-- Usando la regla DCG
                ]
            )
        ]
    ).

% Predicado auxiliar DCG para generar filas HTML
profesores_filas([]) --> [].
profesores_filas([profesor(P, N, G)|Rest]) -->
    html(tr([td(P), td(N), td(G)])),
    profesores_filas(Rest).
