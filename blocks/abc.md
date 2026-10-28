<!-- Собрано автоматически из справки render_block_docs — правки в основном репозитории Spiridus. -->

# `abc` — ноты

Нотация ABC: заголовок (`X:`, `T:` название, `M:` размер, `L:` длительность, `K:` тональность),
затем мелодия. Кнопка под станом проигрывает её.

```abc
X:1
T:В лесу родилась ёлочка
M:2/4
L:1/8
K:C
G | E E D E | C G G2 | E E D E | C2 z
```

Не больше 8 КБ. Кириллица в заголовках и подписях работает.

Несколько голосов — `V:1`, `V:2`… в заголовке (`name="Бас" clef=bass`) и в нотах. Инструмент голоса —
строка `%%MIDI program <номер>` под первым `V:` голоса; звучат только инструменты, чьи сэмплы есть у
нас: 0 — рояль (по умолчанию), 18 — рок-орган, 25 — акустическая гитара, 29 — гитара с перегрузом,
30 — гитара с дисторшном, 34 — бас-гитара, 54 — синтетический голос, 81 — синтезатор «пила». Инструмент
без сэмплов молчит. Гитары и бас записывают октавой выше звучания —
`%%MIDI transpose -12` под голосом опускает звук.

Барабаны — голос `clef=perc` со строкой `%%MIDI channel 10`; звук ноты задаёт `%%percmap` в заголовке:
`%%percmap F bass-drum-1`, `%%percmap c acoustic-snare`, `%%percmap g closed-hi-hat x` (последнее —
головка ноты), имена — по списку General MIDI (`crash-cymbal-1`, `high-tom`, `low-floor-tom`…).

На широком экране строки нот — как в записи. В узкой колонке (телефон, уже 560 точек) стан
занимает её ширину, а такты переносятся сами: по 2 такта в строке (по 3 — от 420 точек). Если
`render_check` всё же пишет `too-small` или `label-small`, сократите строку: меньше нот в такте
(`L:1/8` вместо `1/16`), реже аккорды и текст под нотами.

## Рок-аранжировка на шесть инструментов

Та же «Ёлочка» — для соло-гитары, органа, акустической гитары с боем, ритм-гитары, баса и барабанов:
вступление, куплеты, припев, соло, брейк и последний куплет на тон выше, около полутора минут.
Каждый голос играет своим инструментом — строка `%%MIDI program` под голосом (номер по списку General
MIDI), барабаны — `%%MIDI channel 10`, а `%%percmap` назначает нотам на ударном стане звуки: бочку,
малый барабан, хай-хэт, тарелку и томы. Музыка Леонида Бекмана — общественное достояние; стихи Раисы
Кудашевой охраняются до 2034 года, поэтому аранжировка без текста.

Гитары и бас записаны, как принято, октавой выше звучания, а `%%MIDI transpose -12` под голосом
опускает их звук на место. Бой акустической гитары записан аккордами: удар вниз — все струны, вверх — три верхние, глушение —
короткий аккорд со стаккато.

```abc
X:1
T:В лесу родилась ёлочка — рок
C:музыка Л. Бекмана, аранжировка Spiridus
M:4/4
L:1/8
Q:1/4=140
%%percmap F bass-drum-1
%%percmap c acoustic-snare
%%percmap g closed-hi-hat x
%%percmap a crash-cymbal-1 x
%%percmap e high-tom
%%percmap d low-mid-tom
%%percmap A low-floor-tom
V:1 clef=treble name="Соло-гитара"
V:2 clef=treble name="Орган"
V:3 clef=treble name="Акустика, бой"
V:4 clef=treble name="Ритм-гитара"
V:5 clef=bass name="Бас"
V:6 clef=perc name="Барабаны"
K:C
% Вступление
V:1
%%MIDI program 29
"^Вступление" z8 | z8 | z8 | z7 G |
V:2
%%MIDI program 18
[CEG]8 | [A,CE]8 | [A,CF]8 | [B,DG]8 |
V:3
%%MIDI program 25
%%MIDI transpose -12
z8 | z8 | z8 | z8 |
V:4
%%MIDI program 30
%%MIDI transpose -12
[CGc]8 | [A,EA]8 | [F,CF]8 | [G,DG]8 |
V:5
%%MIDI program 34
%%MIDI transpose -12
C, C, C, C, C, C, C, C, | A,, A,, A,, A,, A,, A,, A,, A,, | F,, F,, F,, F,, F,, F,, F,, F,, | G,, G,, G,, G,, G,, G,, G,, G,, |
V:6
%%MIDI channel 10
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | c c e e d d A A |
% Куплет
V:1
"^Куплет" E E D E C G G2 | E E D E C2 z G | A A F A G E C2 | D D E D C2 z G |
V:2
[CEG]8 | [A,CE]8 | [A,CF]4 [CEG]4 | [B,DG]4 [CEG]4 |
V:3
[CEGce] [CEGce] [Gce] .[CEGc] [Gce] [CEGce] [Gce] .[CEGc] | [A,EAce] [A,EAce] [Ace] .[A,EAc] [Ace] [A,EAce] [Ace] .[A,EAc] | [F,CFAc] [F,CFAc] [FAc] .[F,CFA] [Gce] [CEGce] [Gce] .[CEGc] | [G,B,DGBd] [G,B,DGBd] [GBd] .[G,B,DG] [Gce] [CEGce] [Gce] .[CEGc] |
V:4
.[CGc] .[CGc] .[CGc] .[CGc] .[CGc] .[CGc] .[CGc] .[CGc] | .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] | .[F,CF] .[F,CF] .[F,CF] .[F,CF] .[CGc] .[CGc] .[CGc] .[CGc] | .[G,DG] .[G,DG] .[G,DG] .[G,DG] .[CGc] .[CGc] .[CGc] .[CGc] |
V:5
C, C, C, C, C, C, C, C, | A,, A,, A,, A,, A,, A,, A,, A,, | F,, F,, F,, F,, C, C, C, C, | G,, G,, G,, G,, C, C G, F, |
V:6
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
% Куплет: орган удваивает мелодию
V:1
"^Куплет: орган удваивает мелодию" E E D E C G G2 | E E D E C2 z G | A A F A G E C2 | D D E D C2 z G |
V:2
e e d e c g g2 | e e d e c2 z g | a a f a g e c2 | d d e d c2 z g |
V:3
[CEGce] [CEGce] [Gce] .[CEGc] [Gce] [CEGce] [Gce] .[CEGc] | [A,EAce] [A,EAce] [Ace] .[A,EAc] [Ace] [A,EAce] [Ace] .[A,EAc] | [F,CFAc] [F,CFAc] [FAc] .[F,CFA] [Gce] [CEGce] [Gce] .[CEGc] | [G,B,DGBd] [G,B,DGBd] [GBd] .[G,B,DG] [Gce] [CEGce] [Gce] .[CEGc] |
V:4
[CGc]8 | [A,EA]8 | [F,CF]4 [CGc]4 | [G,DG]4 [CGc]4 |
V:5
C, C, C, C, C, C, C, C, | A,, A,, A,, A,, A,, A,, A,, A,, | F,, F,, F,, F,, C, C, C, C, | G,, G,, G,, G,, C, C G, F, |
V:6
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
% Припев: мелодия октавой выше
V:1
"^Припев: мелодия октавой выше" e e d e c g g2 | e e d e c2 z g | a a f a g e c2 | d d e d c2 z g |
V:2
[CEG]8 | [A,CE]8 | [A,CF]4 [CEG]4 | [B,DG]4 [CEG]4 |
V:3
[CEGce] [CEGce] [Gce] .[CEGc] [Gce] [CEGce] [Gce] .[CEGc] | [A,EAce] [A,EAce] [Ace] .[A,EAc] [Ace] [A,EAce] [Ace] .[A,EAc] | [F,CFAc] [F,CFAc] [FAc] .[F,CFA] [Gce] [CEGce] [Gce] .[CEGc] | [G,B,DGBd] [G,B,DGBd] [GBd] .[G,B,DG] [Gce] [CEGce] [Gce] .[CEGc] |
V:4
[CGc]8 | [A,EA]8 | [F,CF]4 [CGc]4 | [G,DG]4 [CGc]4 |
V:5
C, C, C, C, C, C, C, C, | A,, A,, A,, A,, A,, A,, A,, A,, | F,, F,, F,, F,, C, C, C, C, | G,, G,, G,, G,, C, C G, F, |
V:6
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
% Соло
V:1
"^Соло" c d e2 g e d2 | c A c2 e3 c | f2 e d c2 A2 | B d g2 f d B2 |
V:2
[CEG]8 | [A,CE]8 | [A,CF]8 | [B,DG]8 |
V:3
[CEGce] [CEGce] [Gce] .[CEGc] [Gce] [CEGce] [Gce] .[CEGc] | [A,EAce] [A,EAce] [Ace] .[A,EAc] [Ace] [A,EAce] [Ace] .[A,EAc] | [F,CFAc] [F,CFAc] [FAc] .[F,CFA] [FAc] [F,CFAc] [FAc] .[F,CFA] | [G,B,DGBd] [G,B,DGBd] [GBd] .[G,B,DG] [GBd] [G,B,DGBd] [GBd] .[G,B,DG] |
V:4
[CGc]8 | [A,EA]8 | [F,CF]8 | [G,DG]8 |
V:5
C, C, C, C, C, C, C, C, | A,, A,, A,, A,, A,, A,, A,, A,, | F,, F,, F,, F,, F,, F,, F,, F,, | G,, G,, G,, G,, G,, G, D, C, |
V:6
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
% Соло, продолжение
V:1
"^Соло, продолжение" c e g c' a2 g2 | e g a2 g e c2 | f a c'2 b g d2 | c4 z3 G |
V:2
[CEG]8 | [A,CE]8 | [A,CF]4 [B,DG]4 | [CEG]8 |
V:3
[CEGce] [CEGce] [Gce] .[CEGc] [Gce] [CEGce] [Gce] .[CEGc] | [A,EAce] [A,EAce] [Ace] .[A,EAc] [Ace] [A,EAce] [Ace] .[A,EAc] | [F,CFAc] [F,CFAc] [FAc] .[F,CFA] [GBd] [G,B,DGBd] [GBd] .[G,B,DG] | [CEGce] [CEGce] [Gce] .[CEGc] [Gce] [CEGce] [Gce] .[CEGc] |
V:4
[CGc]8 | [A,EA]8 | [F,CF]4 [G,DG]4 | [CGc]8 |
V:5
C, C, C, C, C, C, C, C, | A,, A,, A,, A,, A,, A,, A,, A,, | F,, F,, F,, F,, G,, G,, G,, G,, | C, C, C, C, C, C G, F, |
V:6
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | c c e e d d A A |
% Брейк
V:1
"^Брейк" z8 | z8 | z8 | z7 A |
V:2
[CEG]8 | [A,CE]8 | [A,CF]8 | [B,DG]8 |
V:3
z8 | z8 | z8 | z8 |
V:4
z8 | z8 | z8 | z8 |
V:5
C,4 C,4 | A,,4 A,,4 | F,,4 F,,4 | G,,4 G,,4 |
V:6
[Fa] g g g [cg] g g g | [Fg] g g g [cg] g g g | [Fg] g g g [cg] g g g | c c e e d d A A |
% Куплет на тон выше
V:1
[K:D clef=treble] "^Куплет на тон выше" F F E F D A A2 | F F E F D2 z A | B B G B A F D2 | E E F E D2 z A |
V:2
[K:D clef=treble] f f e f d a a2 | f f e f d2 z a | b b g b a f d2 | e e f e d2 z a |
V:3
[K:D clef=treble] [DAdf] [DAdf] [Adf] .[DAdf] [Adf] [DAdf] [Adf] .[DAdf] | [B,FBdf] [B,FBdf] [Bdf] .[B,FBd] [Bdf] [B,FBdf] [Bdf] .[B,FBd] | [G,B,DGBd] [G,B,DGBd] [GBd] .[G,B,DG] [Adf] [DAdf] [Adf] .[DAdf] | [A,EAce] [A,EAce] [Ace] .[A,EAc] [Adf] [DAdf] [Adf] .[DAdf] |
V:4
[K:D clef=treble] [DAd]8 | [B,FB]8 | [G,DG]4 [DAd]4 | [A,EA]4 [DAd]4 |
V:5
[K:D clef=bass] D, D, D, D, D, D, D, D, | B,, B,, B,, B,, B,, B,, B,, B,, | G,, G,, G,, G,, D, D, D, D, | A,, A,, A,, A,, D, D A, G, |
V:6
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
% Припев
V:1
"^Припев" f f e f d a a2 | f f e f d2 z a | b b g b a f d2 | e e f e d2 z a |
V:2
[DFA]8 | [B,DF]8 | [B,DG]4 [DFA]4 | [CEA]4 [DFA]4 |
V:3
[DAdf] [DAdf] [Adf] .[DAdf] [Adf] [DAdf] [Adf] .[DAdf] | [B,FBdf] [B,FBdf] [Bdf] .[B,FBd] [Bdf] [B,FBdf] [Bdf] .[B,FBd] | [G,B,DGBd] [G,B,DGBd] [GBd] .[G,B,DG] [Adf] [DAdf] [Adf] .[DAdf] | [A,EAce] [A,EAce] [Ace] .[A,EAc] [Adf] [DAdf] [Adf] .[DAdf] |
V:4
[DAd]8 | [B,FB]8 | [G,DG]4 [DAd]4 | [A,EA]4 [DAd]4 |
V:5
D, D, D, D, D, D, D, D, | B,, B,, B,, B,, B,, B,, B,, B,, | G,, G,, G,, G,, D, D, D, D, | A,, A,, A,, A,, D, D A, G, |
V:6
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
% Припев и концовка
V:1
"^Припев и концовка" f f e f d a a2 | f f e f d2 z a | b b g b a f d2 | d'8 |]
V:2
[DFA]8 | [B,DF]8 | [B,DG]4 [DFA]4 | [DFA]8 |]
V:3
[DAdf] [DAdf] [Adf] .[DAdf] [Adf] [DAdf] [Adf] .[DAdf] | [B,FBdf] [B,FBdf] [Bdf] .[B,FBd] [Bdf] [B,FBdf] [Bdf] .[B,FBd] | [G,B,DGBd] [G,B,DGBd] [GBd] .[G,B,DG] [Adf] [DAdf] [Adf] .[DAdf] | [DAdf]8 |]
V:4
[DAd]8 | [B,FB]8 | [G,DG]4 [DAd]4 | [DAd]8 |]
V:5
D, D, D, D, D, D, D, D, | B,, B,, B,, B,, B,, B,, B,, B,, | G,, G,, G,, G,, D, D, D, D, | D,8 |]
V:6
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g | [Fa]8 |]
```
