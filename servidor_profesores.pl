% ============================================================
% Servidor SWI-Prolog: asignacion de profesores - FCI UNACAR
% ============================================================
% Ejecutar:   swipl -s servidor_profesores.pl
% Abrir:      http://localhost:8080/home
% Detener:    ?- http_stop_server(8080, []).   y luego   ?- halt.
% ============================================================

:- use_module(library(http/http_server)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(lists)).

% asignacion(Tipo, IdEntidad, EmpleadoProfesor)
% Tipo: academia, cuerpo, proyecto, curso, capacitacion
:- dynamic asignacion/3.

% ------------------------------------------------------------
% BASE DE CONOCIMIENTO
% ------------------------------------------------------------

% profesor(Empleado, Nombre, GradoAcademico, Especialidad, CursosQueDomina)
% CursosQueDomina va de mayor a menor dominio.
profesor(1001, 'Ana Lopez Reyes',   doctorado,    [inteligencia_artificial, sistemas_expertos], [c_ia, c_prolog, c_algoritmos]).
profesor(1002, 'Carlos Mendez Cruz', maestria,    [bases_de_datos, ingenieria_software],        [c_bd, c_isw, c_web]).
profesor(1003, 'Laura Perez Gil',   doctorado,    [redes_neuronales, algoritmos],               [c_algoritmos, c_ia, c_paralela]).
profesor(1004, 'Jorge Ramos Diaz',  maestria,     [programacion, paralelo],                     [c_paralela, c_web, c_prolog]).
profesor(1005, 'Marta Silva Ortiz', licenciatura, [web, ingenieria_software],                   [c_web, c_isw, c_bd]).

% estudio(Empleado, Nivel, Titulo, Area)
estudio(1001, licenciatura, 'Ing. en Sistemas',           programacion).
estudio(1001, maestria,     'Maestria en Computacion',    inteligencia_artificial).
estudio(1001, doctorado,    'Doctorado en IA',            sistemas_expertos).
estudio(1002, licenciatura, 'Ing. en Sistemas',           programacion).
estudio(1002, maestria,     'Maestria en Bases de Datos', bases_de_datos).
estudio(1003, licenciatura, 'Ing. en Computacion',        algoritmos).
estudio(1003, maestria,     'Maestria en Computacion',    algoritmos).
estudio(1003, doctorado,    'Doctorado en Redes Neuronales', redes_neuronales).
estudio(1004, licenciatura, 'Ing. en Sistemas',           programacion).
estudio(1004, maestria,     'Maestria en Computo Paralelo', paralelo).
estudio(1005, licenciatura, 'Lic. en Informatica',        web).

% acreditacion(Empleado, Nombre, Tema)
acreditacion(1001, 'Certificacion en Prolog',        sistemas_expertos).
acreditacion(1002, 'Certificacion en SQL',           bases_de_datos).
acreditacion(1004, 'Certificacion en Concurrencia',  paralelo).
acreditacion(1005, 'Certificacion en Desarrollo Web', web).

% capacitacion_tomada(Empleado, IdCursoCapacitacion)
capacitacion_tomada(1001, cc2).
capacitacion_tomada(1002, cc3).
capacitacion_tomada(1004, cc1).

% academia(Id, Nombre, MateriasAsignadas, Lider)
academia(a1, 'Academia de Inteligencia Artificial', [c_ia, c_prolog],       1001).
academia(a2, 'Academia de Ingenieria de Software',  [c_isw, c_web, c_bd],   1002).
academia(a3, 'Academia de Algoritmos y Paralelismo',[c_algoritmos, c_paralela], 1003).

% cuerpo_academico(Id, Nombre, LineaInvestigacion, Lider, Estatus)
cuerpo_academico(ca1, 'Computacion Inteligente',   'Aprendizaje automatico',      1003, consolidado).
cuerpo_academico(ca2, 'Sistemas de Informacion',   'Ingenieria de software y datos', 1002, en_consolidacion).

% proyecto(Id, Nombre, Objetivo, Entregables, Lider, FechaInicio, FechaEntrega)
% Los integrantes se guardan como asignaciones.
proyecto(pr1, 'Sistema experto de diagnostico', 'Apoyar el diagnostico de fallas',
         [base_de_conocimiento, motor_de_inferencia, interfaz], 1001, '2026-02-01', '2026-11-30').
proyecto(pr2, 'Portal academico web', 'Publicar informacion de cursos y profesores',
         [prototipo, portal, manual], 1005, '2026-03-01', '2026-12-15').

% curso(Id, Creditos, Nombre, Objetivo, Academia)
curso(c_ia,        5, 'Inteligencia Artificial', 'Conocer tecnicas de IA',          a1).
curso(c_prolog,    4, 'Programacion en Prolog',  'Programar con logica',            a1).
curso(c_isw,       5, 'Ingenieria de Software',  'Aplicar procesos de software',    a2).
curso(c_web,       4, 'Programacion Web',        'Construir aplicaciones web',      a2).
curso(c_bd,        5, 'Bases de Datos',          'Disenar bases de datos',          a2).
curso(c_algoritmos,5, 'Algoritmos',              'Analizar y disenar algoritmos',   a3).
curso(c_paralela,  4, 'Programacion Paralela',   'Programar de forma concurrente',  a3).

% curso_cap(Id, Nombre, Objetivo, Horas, FechaInicio, FechaConclusion)
curso_cap(cc1, 'Taller de concurrencia',   'Practicar concurrencia',        20, '2026-11-02', '2026-11-06').
curso_cap(cc2, 'Taller de Prolog avanzado','Profundizar en Prolog',         20, '2026-11-09', '2026-11-13').
curso_cap(cc3, 'Curso de SQL avanzado',    'Optimizar consultas',           30, '2026-11-16', '2026-11-27').
curso_cap(cc4, 'Redes neuronales aplicadas','Aplicar redes neuronales',     40, '2026-12-01', '2026-12-11').

% tema(Tipo, Id, Tema): temas que requiere cada entidad
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

tema(curso, c_ia,        inteligencia_artificial).
tema(curso, c_prolog,    sistemas_expertos).
tema(curso, c_prolog,    programacion).
tema(curso, c_isw,       ingenieria_software).
tema(curso, c_web,       web).
tema(curso, c_bd,        bases_de_datos).
tema(curso, c_algoritmos,algoritmos).
tema(curso, c_paralela,  paralelo).

tema(capacitacion, cc1, paralelo).
tema(capacitacion, cc2, sistemas_expertos).
tema(capacitacion, cc3, bases_de_datos).
tema(capacitacion, cc4, redes_neuronales).
tema(capacitacion, cc4, inteligencia_artificial).

% ------------------------------------------------------------
% ENTIDADES (nombre segun tipo)
% ------------------------------------------------------------
entidad(academia,     Id, N) :- academia(Id, N, _, _).
entidad(cuerpo,       Id, N) :- cuerpo_academico(Id, N, _, _, _).
entidad(proyecto,     Id, N) :- proyecto(Id, N, _, _, _, _, _).
entidad(curso,        Id, N) :- curso(Id, _, N, _, _).
entidad(capacitacion, Id, N) :- curso_cap(Id, N, _, _, _, _).

% ------------------------------------------------------------
% REGLAS DE PERFIL (puntaje profesor - entidad)
% ------------------------------------------------------------
% Peso de cada fuente: especialidad 3, estudios 2,
% capacitaciones tomadas 1, acreditaciones 1.
peso_prof(Prof, T, 3) :- profesor(Prof, _, _, E, _), memberchk(T, E).
peso_prof(Prof, T, 2) :- estudio(Prof, _, _, T).
peso_prof(Prof, T, 1) :- capacitacion_tomada(Prof, C), tema(capacitacion, C, T).
peso_prof(Prof, T, 1) :- acreditacion(Prof, _, T).

% Bono por grado academico (solo si ya hay coincidencia)
bono_grado(Prof, B) :- profesor(Prof, _, G, _, _), bono(G, B).
bono(doctorado, 2).
bono(maestria, 1).
bono(licenciatura, 0).

temas_score(Prof, Tipo, Id, S) :-
    findall(M,
            ( tema(Tipo, Id, T),
              findall(W, peso_prof(Prof, T, W), Ws),
              Ws \== [],
              max_list(Ws, M) ),
            Ms),
    sum_list(Ms, S).

% Para cursos: cuanto mas arriba en su lista de dominio, mas puntos
dominio_score(Prof, Tipo, Id, S) :-
    (   Tipo == curso,
        profesor(Prof, _, _, _, Cs),
        nth1(K, Cs, Id)
    ->  length(Cs, N),
        S is 10 + N - K + 1
    ;   S = 0
    ).

puntaje(Prof, Tipo, Id, P) :-
    temas_score(Prof, Tipo, Id, S1),
    dominio_score(Prof, Tipo, Id, S2),
    S0 is S1 + S2,
    bono_grado(Prof, B),
    (   S0 > 0 -> P is S0 + B ; P = 0 ).

% ranking(+Tipo, +Id, -Lista): lista NP-Prof ordenada (NP = -Puntaje)
ranking(Tipo, Id, Rank) :-
    findall(NP-Prof,
            ( profesor(Prof, _, _, _, _),
              puntaje(Prof, Tipo, Id, P),
              P > 0,
              NP is -P ),
            L),
    sort(0, @=<, L, Rank).

% candidatos: igual que ranking pero con umbral y sin repetidos
candidatos(Tipo, Id, U, Rank) :-
    findall(NP-Prof,
            ( profesor(Prof, _, _, _, _),
              \+ asignacion(Tipo, Id, Prof),
              \+ ( Tipo == capacitacion, capacitacion_tomada(Prof, Id) ),
              puntaje(Prof, Tipo, Id, P),
              P >= U,
              NP is -P ),
            L),
    sort(0, @=<, L, Rank).

% ------------------------------------------------------------
% SERVIDOR: rutas
% ------------------------------------------------------------
:- http_handler(root(.),                       inicio,               []).
:- http_handler(root(home),                    inicio,               []).
:- http_handler(root(api/profesores),          api_profesores,       []).
:- http_handler(root(api/profesor),            api_profesor,         []).
:- http_handler(root(api/sugerir),             api_sugerir,          []).
:- http_handler(root(api/asignaciones),        api_asignaciones,     []).
:- http_handler(root(api/academias/asignar),   api_asignar_academia, []).
:- http_handler(root(api/cuerpos/asignar),     api_asignar_cuerpo,   []).
:- http_handler(root(api/proyectos/asignar),   api_asignar_proyecto, []).
:- http_handler(root(api/cursos/asignar),      api_asignar_curso,    []).
:- http_handler(root(api/capacitaciones/asignar), api_asignar_capacitacion, []).

:- initialization(http_server([port(8080)])).

inicio(_Request) :-
    format('Content-type: text/html~n~n'),
    format('<html><head><title>Asignacion de profesores</title></head><body>~n'),
    format('<h1>Asignacion de profesores - FCI UNACAR</h1>~n<ul>~n'),
    format('<li>/api/profesores</li>~n'),
    format('<li>/api/profesor?nombre=Ana  &oacute;  /api/profesor?id=1001</li>~n'),
    format('<li>/api/sugerir?tipo=academia&amp;id=a1</li>~n'),
    format('<li>/api/academias/asignar?id=a1</li>~n'),
    format('<li>/api/cuerpos/asignar?id=ca1</li>~n'),
    format('<li>/api/proyectos/asignar?id=pr1</li>~n'),
    format('<li>/api/cursos/asignar?id=c_ia</li>~n'),
    format('<li>/api/capacitaciones/asignar?id=cc4</li>~n'),
    format('<li>/api/asignaciones</li>~n'),
    format('</ul>~n'),
    format('<p>Parametros opcionales de asignar: profesor=EMPLEADO, umbral=N, maximo=N</p>~n'),
    format('</body></html>~n').

% ---- listado de profesores ----
api_profesores(_Request) :-
    findall(Id, profesor(Id, _, _, _, _), Ids),
    maplist(profesor_json, Ids, Js),
    reply_json(json([profesores=Js])).

% ---- opcion 6: buscar profesor y sus asignaciones ----
api_profesor(Request) :-
    http_parameters(Request,
                    [ id(IdQ,      [integer, default(0)]),
                      nombre(NomQ, [atom,    default('')])
                    ]),
    findall(Id,
            ( profesor(Id, N, _, _, _), coincide(Id, N, IdQ, NomQ) ),
            Ids),
    maplist(profesor_json, Ids, Js),
    reply_json(json([resultados=Js])).

coincide(Id, _, IdQ, _) :- IdQ > 0, !, Id =:= IdQ.
coincide(_, N, _, Q) :-
    Q \== '',
    downcase_atom(N, NL),
    downcase_atom(Q, QL),
    sub_atom(NL, _, _, _, QL).

profesor_json(Id, json([ empleado=Id, nombre=N, grado=G, especialidad=E,
                         cursos_que_domina=C, estudios=Es, acreditaciones=Ac,
                         capacitaciones_tomadas=Ca, asignaciones=As ])) :-
    profesor(Id, N, G, E, C),
    findall(json([nivel=Ni, titulo=T, area=A]), estudio(Id, Ni, T, A), Es),
    findall(json([nombre=An, tema=At]), acreditacion(Id, An, At), Ac),
    findall(json([id=Ci, nombre=Cn]),
            ( capacitacion_tomada(Id, Ci), curso_cap(Ci, Cn, _, _, _, _) ),
            Ca),
    findall(json([tipo=Ti, id=Ei, nombre=En]),
            ( asignacion(Ti, Ei, Id), entidad(Ti, Ei, En) ),
            As).

% ---- sugerencias (ranking sin asignar) ----
api_sugerir(Request) :-
    http_parameters(Request, [tipo(Tipo, [atom]), id(Id, [atom])]),
    (   entidad(Tipo, Id, Nombre)
    ->  ranking(Tipo, Id, Rank),
        maplist(fila_ranking, Rank, Filas),
        reply_json(json([tipo=Tipo, id=Id, nombre=Nombre, candidatos=Filas]))
    ;   reply_json(json([error='entidad no encontrada']), [status(404)])
    ).

fila_ranking(NP-Prof, json([empleado=Prof, nombre=N, puntaje=P])) :-
    profesor(Prof, N, _, _, _),
    P is -NP.

% ---- todas las asignaciones ----
api_asignaciones(_Request) :-
    findall(json([tipo=T, id=I, nombre=N, profesor=P]),
            ( asignacion(T, I, P), entidad(T, I, N) ),
            L),
    reply_json(json([asignaciones=L])).

% ---- opciones 1 a 5: asignar ----
api_asignar_academia(R)      :- asignar_http(R, academia).
api_asignar_cuerpo(R)        :- asignar_http(R, cuerpo).
api_asignar_proyecto(R)      :- asignar_http(R, proyecto).
api_asignar_curso(R)         :- asignar_http(R, curso).
api_asignar_capacitacion(R)  :- asignar_http(R, capacitacion).

asignar_http(Request, Tipo) :-
    http_parameters(Request,
                    [ id(Id,        [atom]),
                      profesor(Prof,[integer, default(0)]),
                      umbral(U0,    [integer, default(3)]),
                      maximo(M0,    [integer, default(3)])
                    ]),
    (   entidad(Tipo, Id, Nombre)
    ->  limites(Tipo, U0, M0, U, M),
        (   Prof > 0
        ->  asignar_manual(Tipo, Id, Prof, Res)
        ;   asignar_auto(Tipo, Id, U, M, Res)
        ),
        reply_json(json([tipo=Tipo, id=Id, nombre=Nombre, resultado=Res]))
    ;   reply_json(json([error='entidad no encontrada']), [status(404)])
    ).

% Un curso a impartir lleva solo al mejor profesor
limites(curso, _, _, 1, 1) :- !.
limites(_, U, M, U, M).

% curso que ya tiene profesor
asignar_auto(curso, Id, _, _,
             json([mensaje='el curso ya tiene profesor asignado', profesor=P])) :-
    asignacion(curso, Id, P), !.
asignar_auto(Tipo, Id, U, M, json([asignados=L])) :-
    candidatos(Tipo, Id, U, Rank),
    (   length(Rank, Len), Len > M
    ->  length(Top, M), append(Top, _, Rank)
    ;   Top = Rank
    ),
    maplist(registrar(Tipo, Id), Top, L).

registrar(Tipo, Id, NP-Prof, json([empleado=Prof, nombre=N, puntaje=P])) :-
    assertz(asignacion(Tipo, Id, Prof)),
    profesor(Prof, N, _, _, _),
    P is -NP.

asignar_manual(Tipo, Id, Prof, Res) :-
    (   \+ profesor(Prof, _, _, _, _)
    ->  Res = json([error='el profesor no existe'])
    ;   asignacion(Tipo, Id, Prof)
    ->  Res = json([error='el profesor ya estaba asignado'])
    ;   Tipo == capacitacion, capacitacion_tomada(Prof, Id)
    ->  Res = json([error='el profesor ya tomo ese curso'])
    ;   puntaje(Prof, Tipo, Id, P), P =:= 0
    ->  Res = json([error='perfil no compatible', puntaje=0])
    ;   puntaje(Prof, Tipo, Id, P),
        assertz(asignacion(Tipo, Id, Prof)),
        Res = json([asignados=[json([empleado=Prof, puntaje=P])]])
    ).
