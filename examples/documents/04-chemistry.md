<!-- Собрано из apps/playground/examples/04-chemistry.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Химия | теги: smiles, mol3d, mhchem, молекулы, реакции -->
# Химия: формулы и молекулы

Уравнения mhchem прямо в тексте: $\ce{CH4 + 2O2 -> CO2 + 2H2O}$, $\ce{Fe^{3+} + 3OH- -> Fe(OH)3 v}$, количество $\pu{1.5 mol/L}$.

Структурная формула по SMILES — аспирин:

```smiles
CC(=O)Oc1ccccc1C(=O)O
```

Схема реакции — этерификация:

```smiles
CC(=O)O.CCO>[H+]>CC(=O)OCC.O
```

Молекула в 3D — потяните, чтобы повернуть; двойное нажатие возвращает вид:

```mol3d
CCO
```

```mol3d
OC[C@H]1OC(O)[C@H](O)[C@@H](O)[C@@H]1O
```
