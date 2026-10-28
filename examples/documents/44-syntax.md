<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Язык | теги: синтаксис, синтаксический разбор, дерево зависимостей, conllu, universal dependencies, члены предложения, части речи, udpipe, stanza, slovnet, русский язык -->
# Синтаксический разбор: дерево зависимостей

Блок `conllu` рисует разбор предложения так, как его видит синтаксический анализатор: над словами —
дуги от главного слова к зависимому, под словами — часть речи. Подписи — терминами Universal
Dependencies, школьными или обоими сразу (кнопки над разбором). Разбор делает MCP-инструмент
`text_parse` — текст и анализаторы на входе, готовый блок на выходе.

## Три анализатора на одних предложениях

UDPipe 2 — образец, Stanza и Slovnet сравниваются с ним: где связь ведёт к другому главному слову
или названа иначе, дуга и подпись выделены цветом. Кнопки «анализаторы» прячут и показывают разборы.

```conllu
# parser = udpipe2
# sent_id = 1
# text = Старый кот медленно пил тёплое молоко, которое ему налили.
1	Старый	старый	ADJ	_	Case=Nom|Degree=Pos|Gender=Masc|Number=Sing	2	amod	_	_
2	кот	кот	NOUN	_	Animacy=Anim|Case=Nom|Gender=Masc|Number=Sing	4	nsubj	_	_
3	медленно	медленно	ADV	_	Degree=Pos	4	advmod	_	_
4	пил	пить	VERB	_	Aspect=Imp|Gender=Masc|Mood=Ind|Number=Sing|Tense=Past|VerbForm=Fin|Voice=Act	0	root	_	_
5	тёплое	теплый	ADJ	_	Case=Acc|Degree=Pos|Gender=Neut|Number=Sing	6	amod	_	_
6	молоко	молоко	NOUN	_	Animacy=Inan|Case=Acc|Gender=Neut|Number=Sing	4	obj	_	_
7	,	,	PUNCT	_	_	10	punct	_	_
8	которое	который	DET	_	Case=Acc|Gender=Neut|Number=Sing|PronType=Rel	10	obj	_	_
9	ему	он	PRON	_	Case=Dat|Gender=Masc|Number=Sing|Person=3|PronType=Prs	10	iobj	_	_
10	налили	налить	VERB	_	Aspect=Perf|Mood=Ind|Number=Plur|Tense=Past|VerbForm=Fin|Voice=Act	6	acl:relcl	_	_
11	.	.	PUNCT	_	_	4	punct	_	_

# parser = udpipe2
# sent_id = 2
# text = Мой брат читает книгу о море.
1	Мой	мой	DET	_	Case=Nom|Gender=Masc|Number=Sing|Poss=Yes|PronType=Prs	2	det	_	_
2	брат	брат	NOUN	_	Animacy=Anim|Case=Nom|Gender=Masc|Number=Sing	3	nsubj	_	_
3	читает	читать	VERB	_	Aspect=Imp|Mood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin|Voice=Act	0	root	_	_
4	книгу	книга	NOUN	_	Animacy=Inan|Case=Acc|Gender=Fem|Number=Sing	3	obj	_	_
5	о	о	ADP	_	_	6	case	_	_
6	море	море	NOUN	_	Animacy=Inan|Case=Loc|Gender=Neut|Number=Sing	4	nmod	_	_
7	.	.	PUNCT	_	_	3	punct	_	_

# parser = stanza
# sent_id = 1
# text = Старый кот медленно пил тёплое молоко, которое ему налили.
1	Старый	старый	ADJ	_	Case=Nom|Degree=Pos|Gender=Masc|Number=Sing	2	amod	_	_
2	кот	кот	NOUN	_	Animacy=Anim|Case=Nom|Gender=Masc|Number=Sing	4	nsubj	_	_
3	медленно	медленно	ADV	_	Degree=Pos	4	advmod	_	_
4	пил	пить	VERB	_	Aspect=Imp|Gender=Masc|Mood=Ind|Number=Sing|Tense=Past|VerbForm=Fin|Voice=Act	0	root	_	_
5	тёплое	теплый	ADJ	_	Case=Acc|Degree=Pos|Gender=Neut|Number=Sing	6	amod	_	_
6	молоко	молоко	NOUN	_	Animacy=Inan|Case=Acc|Gender=Neut|Number=Sing	4	obj	_	_
7	,	,	PUNCT	_	_	10	punct	_	_
8	которое	который	PRON	_	Case=Acc|PronType=Int,Rel	10	obj	_	_
9	ему	он	PRON	_	Case=Dat|Gender=Masc|Number=Sing|Person=3|PronType=Prs	10	iobj	_	_
10	налили	налить	VERB	_	Aspect=Perf|Mood=Ind|Number=Plur|Tense=Past|VerbForm=Fin|Voice=Act	6	acl:relcl	_	_
11	.	.	PUNCT	_	_	4	punct	_	_

# parser = stanza
# sent_id = 2
# text = Мой брат читает книгу о море.
1	Мой	мой	DET	_	Case=Nom|Gender=Masc|Number=Sing|Poss=Yes|PronType=Prs	2	det	_	_
2	брат	брат	NOUN	_	Animacy=Anim|Case=Nom|Gender=Masc|Number=Sing	3	nsubj	_	_
3	читает	читать	VERB	_	Aspect=Imp|Mood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin|Voice=Act	0	root	_	_
4	книгу	книга	NOUN	_	Animacy=Inan|Case=Acc|Gender=Fem|Number=Sing	3	obj	_	_
5	о	о	ADP	_	_	6	case	_	_
6	море	море	NOUN	_	Animacy=Inan|Case=Loc|Gender=Neut|Number=Sing	4	nmod	_	_
7	.	.	PUNCT	_	_	3	punct	_	_

# parser = slovnet
# sent_id = 1
# text = Старый кот медленно пил тёплое молоко, которое ему налили.
1	Старый	_	ADJ	_	Case=Nom|Degree=Pos|Gender=Masc|Number=Sing	2	amod	_	_
2	кот	_	NOUN	_	Animacy=Anim|Case=Nom|Gender=Masc|Number=Sing	4	nsubj	_	_
3	медленно	_	ADV	_	Degree=Pos	4	advmod	_	_
4	пил	_	VERB	_	Aspect=Imp|Gender=Masc|Mood=Ind|Number=Sing|Tense=Past|VerbForm=Fin|Voice=Act	0	root	_	_
5	тёплое	_	ADJ	_	Animacy=Inan|Case=Acc|Degree=Pos|Gender=Neut|Number=Sing	6	amod	_	_
6	молоко	_	NOUN	_	Animacy=Inan|Case=Acc|Gender=Neut|Number=Sing	4	obj	_	_
7	,	_	PUNCT	_	_	10	punct	_	_
8	которое	_	PRON	_	Animacy=Inan|Case=Acc|Gender=Neut|Number=Sing	10	obj	_	_
9	ему	_	PRON	_	Case=Dat|Gender=Masc|Number=Sing|Person=3	10	iobj	_	_
10	налили	_	VERB	_	Aspect=Perf|Mood=Ind|Number=Plur|Tense=Past|VerbForm=Fin|Voice=Act	6	acl:relcl	_	_
11	.	_	PUNCT	_	_	4	punct	_	_

# parser = slovnet
# sent_id = 2
# text = Мой брат читает книгу о море.
1	Мой	_	DET	_	Case=Nom|Gender=Masc|Number=Sing	2	det	_	_
2	брат	_	NOUN	_	Animacy=Anim|Case=Nom|Gender=Masc|Number=Sing	3	nsubj	_	_
3	читает	_	VERB	_	Aspect=Imp|Mood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin|Voice=Act	0	root	_	_
4	книгу	_	NOUN	_	Animacy=Inan|Case=Acc|Gender=Fem|Number=Sing	3	obj	_	_
5	о	_	ADP	_	_	6	case	_	_
6	море	_	NOUN	_	Animacy=Inan|Case=Loc|Gender=Neut|Number=Sing	4	nmod	_	_
7	.	_	PUNCT	_	_	3	punct	_	_
```

## Школьные названия, признаки под словом

```conllu terms=school rows=pos,feats
# parser = udpipe2
# sent_id = 1
# text = Старый кот медленно пил тёплое молоко, которое ему налили.
1	Старый	старый	ADJ	_	Case=Nom|Degree=Pos|Gender=Masc|Number=Sing	2	amod	_	_
2	кот	кот	NOUN	_	Animacy=Anim|Case=Nom|Gender=Masc|Number=Sing	4	nsubj	_	_
3	медленно	медленно	ADV	_	Degree=Pos	4	advmod	_	_
4	пил	пить	VERB	_	Aspect=Imp|Gender=Masc|Mood=Ind|Number=Sing|Tense=Past|VerbForm=Fin|Voice=Act	0	root	_	_
5	тёплое	теплый	ADJ	_	Case=Acc|Degree=Pos|Gender=Neut|Number=Sing	6	amod	_	_
6	молоко	молоко	NOUN	_	Animacy=Inan|Case=Acc|Gender=Neut|Number=Sing	4	obj	_	_
7	,	,	PUNCT	_	_	10	punct	_	_
8	которое	который	DET	_	Case=Acc|Gender=Neut|Number=Sing|PronType=Rel	10	obj	_	_
9	ему	он	PRON	_	Case=Dat|Gender=Masc|Number=Sing|Person=3|PronType=Prs	10	iobj	_	_
10	налили	налить	VERB	_	Aspect=Perf|Mood=Ind|Number=Plur|Tense=Past|VerbForm=Fin|Voice=Act	6	acl:relcl	_	_
11	.	.	PUNCT	_	_	4	punct	_	_
```

Наведите на слово — подсказка: часть речи и признаки в обоих видах, связь с её названием в UD и
главное слово.

## Члены предложения, как в школе

Тот же разбор в виде школьного: подчёркивания членов предложения и часть речи над словом. Знак «?» —
там, где разбор анализатора не говорит однозначно, какой это член предложения; кнопка «razbor»
копирует запись, чтобы вставить её в документ и поправить.

```conllu view=school
# parser = udpipe2
# sent_id = 1
# text = Старый кот медленно пил тёплое молоко, которое ему налили.
1	Старый	старый	ADJ	_	Case=Nom|Degree=Pos|Gender=Masc|Number=Sing	2	amod	_	_
2	кот	кот	NOUN	_	Animacy=Anim|Case=Nom|Gender=Masc|Number=Sing	4	nsubj	_	_
3	медленно	медленно	ADV	_	Degree=Pos	4	advmod	_	_
4	пил	пить	VERB	_	Aspect=Imp|Gender=Masc|Mood=Ind|Number=Sing|Tense=Past|VerbForm=Fin|Voice=Act	0	root	_	_
5	тёплое	теплый	ADJ	_	Case=Acc|Degree=Pos|Gender=Neut|Number=Sing	6	amod	_	_
6	молоко	молоко	NOUN	_	Animacy=Inan|Case=Acc|Gender=Neut|Number=Sing	4	obj	_	_
7	,	,	PUNCT	_	_	10	punct	_	_
8	которое	который	DET	_	Case=Acc|Gender=Neut|Number=Sing|PronType=Rel	10	obj	_	_
9	ему	он	PRON	_	Case=Dat|Gender=Masc|Number=Sing|Person=3|PronType=Prs	10	iobj	_	_
10	налили	налить	VERB	_	Aspect=Perf|Mood=Ind|Number=Plur|Tense=Past|VerbForm=Fin|Voice=Act	6	acl:relcl	_	_
11	.	.	PUNCT	_	_	4	punct	_	_
```
