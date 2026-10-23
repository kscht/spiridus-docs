<!-- Собрано из apps/playground/examples/62-lean.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

# Доказательства Lean 4 и Mathlib

Проверка формальных утверждений, цели тактик и граф зависимостей.

## Пример 1

```lean tree=boxes
-- result: artifact:91700277dceaec0e/result.json
-- build: lean-4.34.0
import Mathlib.Tactic

theorem add_zero_right (n : ℕ) : n + 0 = n := by
  induction n with
  | zero => rfl
  | succ k ih => simp
```

## Пример 2

```lean
-- result: artifact:58a8f60ae9e78978/result.json
-- build: lean-4.34.0
import Mathlib.Tactic

theorem square_nonnegative (x : ℝ) : 0 ≤ x ^ 2 := by
  positivity
```

## Пример 3

```lean
-- result: artifact:49794bc7cdb1d7aa/result.json
-- build: lean-4.34.0
import Mathlib.Tactic

def squares (n : ℕ) := (List.range n).map (fun x => x ^ 2)
#eval squares 10
```

## Пример 4

```lean
-- result: artifact:d305a9a4eb914b91/result.json
-- build: lean-4.34.0
import Mathlib.Data.List.Basic

theorem append_nil_right (xs : List ℕ) : xs ++ [] = xs := by
  simp
```

## Пример 5

```lean tree=tree deps=block
-- result: artifact:79b20e16e81ab889/result.json
-- build: lean-4.34.0
import Mathlib.Tactic

theorem sum_constant (n : ℕ) : ∑ _k ∈ Finset.range n, (1 : ℕ) = n := by
  simp
```

## Пример 6

```lean
-- result: artifact:71c1efa0ee004c98/result.json
-- build: lean-4.34.0
import Mathlib.Tactic

def twice (n : ℕ) := n + n
```

## Пример 7

```lean continue deps=document
-- result: artifact:785a1b306a7dc86a/result.json
-- build: lean-4.34.0
lemma twice_eq (n : ℕ) : twice n = 2 * n := by
  simp [twice, two_mul]
```
