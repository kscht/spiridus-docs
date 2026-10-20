<!-- Собрано из apps/playground/examples/45-abc-cover.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Музыка | теги: abc, ноты, кавер, аранжировка, партитура, несколько голосов, барабаны, midi -->
# abc — пример кавера

Партитура на шесть голосов в нотации ABC: соло-гитара, синтезатор, ритм-гитара, бас, барабаны и вокал.
Вступление, куплеты, припевы, соло и финал; тембры инструментов — `%%MIDI program`, барабаны —
`%%percmap` на десятом канале. Мелодия вокала в куплетах и припевах — синтетическим голосом (`%%MIDI program 54`), синтезатор — рок-органом (18), ритм-гитара — с перегрузом (29). Нажмите «играть» слева вверху, чтобы послушать.

```abc
X:1
T:Кавер
C:в духе группы «Кино», аранжировка
M:4/4
L:1/8
Q:1/4=126
%%percmap F bass-drum-1
%%percmap c acoustic-snare
%%percmap g closed-hi-hat x
%%percmap a crash-cymbal-1 x
%%percmap e high-tom
%%percmap d low-mid-tom
%%percmap A low-floor-tom
V:1 clef=treble name="Соло-гитара"
V:2 clef=treble name="Синтезатор"
V:3 clef=treble name="Ритм-гитара"
V:4 clef=bass name="Бас"
V:5 clef=perc name="Барабаны"
V:6 clef=treble name="Вокал"
K:Am
% ===== Вступление =====
V:1
%%MIDI program 29
"^Вступление" |: A2 c e a2 g e | f2 e c A2 c e |
g2 e c G2 c e | d2 B G B2 d2 :|
V:2
%%MIDI program 18
|: [A,CE]8 | [A,CF]8 |
[CEG]8 | [B,DG]8 :|
V:3
%%MIDI program 29
%%MIDI transpose -12
|: [A,EA]2 [A,EA]2 [A,EA]2 [A,EA]2 | [F,CF]2 [F,CF]2 [F,CF]2 [F,CF]2 |
[CGc]2 [CGc]2 [CGc]2 [CGc]2 | [G,DG]2 [G,DG]2 [G,DG]2 [G,DG]2 :|
V:4
%%MIDI program 34
%%MIDI transpose -12
|: A,, A, A,, A, A,, A, A,, A, | F,, F, F,, F, F,, F, F,, F, |
C, C C, C C, C C, C | G,, G, G,, G, G,, G, A,, B,, :|
V:5
%%MIDI channel 10
|: [Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
[Fg] g [cg] g [Fg] [Fg] [cg] g | c c e e d d A A :|
V:6
%%MIDI program 54
|: z8 | z8 |
z8 | z8 :|
% ===== Куплет 1 =====
V:1
"^Куплет" |: z8 | z8 |
z8 | z4 e d c B :|
V:2
|: [A,CE]8 | [A,CF]8 |
[CEG]8 | [B,DG]8 :|
V:3
|: .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] | .[F,CF] .[F,CF] .[F,CF] .[F,CF] .[F,CF] .[F,CF] .[F,CF] .[F,CF] |
.[CGc] .[CGc] .[CGc] .[CGc] .[CGc] .[CGc] .[CGc] .[CGc] | .[G,DG] .[G,DG] .[G,DG] .[G,DG] .[G,DG] .[G,DG] .[G,DG] .[G,DG] :|
V:4
|: A,, A,, A,, A,, A,, A,, A,, A,, | F,, F,, F,, F,, F,, F,, F,, F,, |
C, C, C, C, C, C, C, C, | G,, G,, G,, G,, G,, G,, A,, B,, :|
V:5
|: [Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
[Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g :|
V:6
|: z2 E2 A2 A B | c2 A2 A2 F2 |
G2 E2 G2 c2 | B2 G2 z4 :|
% ===== Припев =====
V:1
"^Припев" |: a4 c'4 | b4 d'4 |
c'4 g4 | a8 :|
V:2
|: [A,CF]8 | [B,DG]8 |
[CEG]8 | [A,CE]8 :|
V:3
|: [F,CF]2 [F,CF]2 [F,CF]2 [F,CF]2 | [G,DG]2 [G,DG]2 [G,DG]2 [G,DG]2 |
[CGc]2 [CGc]2 [CGc]2 [CGc]2 | [A,EA]2 [A,EA]2 [A,EA]2 [A,EA]2 :|
V:4
|: F,, F,, F,, F,, F,, F,, F,, F,, | G,, G,, G,, G,, G,, G,, G,, G,, |
C, C, C, C, C, C, C, C, | A,, A,, A,, A,, A,, A,, G,, E,, :|
V:5
|: [Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
[Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g c e d A :|
V:6
|: c3 c c2 A2 | d3 d d2 B2 |
e2 d2 c2 G2 | A6 z2 :|
% ===== Соло =====
V:1
"^Соло" e a c' a b a g e | f2 a c' a2 g f |
e g c' e' d' c' g e | d g b d' c' b g d |
a2 c'2 e'2 d' c' | c' a f a c'2 a2 |
g e c e g2 e g | b6 z2 |
V:2
[A,CE]8 | [A,CF]8 |
[CEG]8 | [B,DG]8 |
[A,CE]8 | [A,CF]8 |
[CEG]8 | [B,DG]8 |
V:3
[A,EA]4 [A,EA]4 | [F,CF]4 [F,CF]4 |
[CGc]4 [CGc]4 | [G,DG]4 [G,DG]4 |
[A,EA]4 [A,EA]4 | [F,CF]4 [F,CF]4 |
[CGc]4 [CGc]4 | [G,DG]4 [G,DG]4 |
V:4
A,, A,, A,, A,, A,, A,, A,, A,, | F,, F,, F,, F,, F,, F,, F,, F,, |
C, C, C, C, C, C, C, C, | G,, G,, G,, G,, G,, G,, G,, G,, |
A,, A,, A,, A,, A,, A,, A,, A,, | F,, F,, F,, F,, F,, F,, F,, F,, |
C, C, C, C, C, C, C, C, | G,, G,, G,, G,, G,, G,, A,, B,, |
V:5
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
[Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
[Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
[Fg] g [cg] g [Fg] [Fg] [cg] g | c c e e d d A A |
V:6
z8 | z8 |
z8 | z8 |
z8 | z8 |
z8 | z8 |
% ===== Куплет 2 =====
V:1
"^Куплет 2" |: z8 | z8 |
z8 | z4 e d c B :|
V:2
|: [A,CE]8 | [A,CF]8 |
[CEG]8 | [B,DG]8 :|
V:3
|: .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] .[A,EA] | .[F,CF] .[F,CF] .[F,CF] .[F,CF] .[F,CF] .[F,CF] .[F,CF] .[F,CF] |
.[CGc] .[CGc] .[CGc] .[CGc] .[CGc] .[CGc] .[CGc] .[CGc] | .[G,DG] .[G,DG] .[G,DG] .[G,DG] .[G,DG] .[G,DG] .[G,DG] .[G,DG] :|
V:4
|: A,, A,, A,, A,, A,, A,, A,, A,, | F,, F,, F,, F,, F,, F,, F,, F,, |
C, C, C, C, C, C, C, C, | G,, G,, G,, G,, G,, G,, A,, B,, :|
V:5
|: [Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
[Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g :|
V:6
|: z2 E2 A2 A B | c2 A2 A2 F2 |
G2 E2 G2 c2 | B2 G2 z4 :|
% ===== Припев 2 =====
V:1
"^Припев" |: a4 c'4 | b4 d'4 |
c'4 g4 | a8 :|
V:2
|: [A,CF]8 | [B,DG]8 |
[CEG]8 | [A,CE]8 :|
V:3
|: [F,CF]2 [F,CF]2 [F,CF]2 [F,CF]2 | [G,DG]2 [G,DG]2 [G,DG]2 [G,DG]2 |
[CGc]2 [CGc]2 [CGc]2 [CGc]2 | [A,EA]2 [A,EA]2 [A,EA]2 [A,EA]2 :|
V:4
|: F,, F,, F,, F,, F,, F,, F,, F,, | G,, G,, G,, G,, G,, G,, G,, G,, |
C, C, C, C, C, C, C, C, | A,, A,, A,, A,, A,, A,, G,, E,, :|
V:5
|: [Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
[Fg] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g c e d A :|
V:6
|: c3 c c2 A2 | d3 d d2 B2 |
e2 d2 c2 G2 | A6 z2 :|
% ===== Финал =====
V:1
"^Финал" A2 c e a2 g e | f2 e c A2 c e |
g2 e c G2 c e | d2 B G B2 d2 |
[Aea]8 |]
V:2
[A,CE]8 | [A,CF]8 |
[CEG]8 | [B,DG]8 |
[A,CE]8 |]
V:3
[A,EA]2 [A,EA]2 [A,EA]2 [A,EA]2 | [F,CF]2 [F,CF]2 [F,CF]2 [F,CF]2 |
[CGc]2 [CGc]2 [CGc]2 [CGc]2 | [G,DG]2 [G,DG]2 [G,DG]2 [G,DG]2 |
[A,EA]8 |]
V:4
A,, A, A,, A, A,, A, A,, A, | F,, F, F,, F, F,, F, F,, F, |
C, C C, C C, C C, C | G,, G, G,, G, G,, G, A,, B,, |
A,,8 |]
V:5
[Fa] g [cg] g [Fg] [Fg] [cg] g | [Fg] g [cg] g [Fg] [Fg] [cg] g |
[Fg] g [cg] g [Fg] [Fg] [cg] g | c c e e d d A A |
[Fa]8 |]
V:6
z8 | z8 |
z8 | z8 |
z8 |]
```
