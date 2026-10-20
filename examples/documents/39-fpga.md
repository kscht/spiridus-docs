<!-- Собрано из apps/playground/examples/39-fpga.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Схемы | теги: fpga, плис, verilog, vhdl, systemverilog, yosys, nextpnr, ice40, ecp5, симуляция, vcd, осциллограммы, digitaljs, временная диаграмма, wavedrom, spi, uart, axi, регистр, интерфейс, протокол, цифровая схемотехника -->
# FPGA: схемы, ресурсы, осциллограммы

Код на Verilog и VHDL со схемой и ресурсами ПЛИС — блок `hdl` (рисует MCP-инструмент
`hdl_synth`: Yosys, nextpnr), осциллограммы симуляции — блок `vcd` (`hdl_sim`: Icarus Verilog,
Verilator, GHDL), живая схема с переключателями — `digitaljs`, временны́е диаграммы и регистры
вручную — `wavedrom`.

## Схема и ресурсы: счётчик BCD на iCE40

Разряд десятичного счётчика: считает 0…9, в такте перехода 9 → 0 даёт перенос. Синтез под
iCE40 UP5K с целью 100 МГц — nextpnr показывает, что этот кристалл вытягивает около 76 МГц.

```hdl
// result: artifact:f9be5527d2010a65/schematic.svg
// build: hdl-debian13
// Счётчик по модулю 10 с разрешением и переносом — разряд десятичного счётчика
module bcd_counter (
  input  wire       clk,
  input  wire       rst,   // синхронный сброс
  input  wire       en,
  output reg  [3:0] q,
  output wire       carry  // 1 в такте перехода 9 → 0
);
  assign carry = en && (q == 4'd9);
  always @(posedge clk)
    if (rst)        q <= 4'd0;
    else if (carry) q <= 4'd0;
    else if (en)    q <= q + 4'd1;
endmodule
```

## Осциллограммы: тот же счётчик в симуляции

Тестбенч: сброс, счёт, пауза (`en = 0`), снова счёт. Щелчок по осциллограммам ставит курсор —
справа значения всех сигналов в этот момент; кнопка `hex` переключает основание.

```vcd
artifact:da791034da00caa9/wave.vcd
signals: tb.clk, tb.rst, tb.en, tb.q, tb.carry
radix: dec
title: Счётчик BCD: сброс, счёт, пауза
```

## Живая схема: мультиплексор 4 в 1

Входы — щелчком (квадрат залит — единица): `s1 s0` — номер входа, который идёт на выход `y`; на проводах зелёный — 1, красный — 0.

```digitaljs
// result: artifact:e9a893f5089c87a4/circuit.json
// build: hdl-debian13
// Мультиплексор 4 в 1: s1 s0 — номер входа, который идёт на выход
module mux4 (
  input  wire s1, s0,
  input  wire a, b, c, d,
  output wire y
);
  assign y = s1 ? (s0 ? d : c) : (s0 ? b : a);
endmodule
```

## Живая схема: тот же счётчик BCD с осциллограммами

Под схемой — осциллограммы сигналов (раскрыты атрибутом `monitor=on`). Включите `en` (кнопка
под схемой или щелчок по входу), подайте сброс: `rst` в 1, кнопка «такт ⎍», `rst` в 0 — дальше «такт ⎍» по одному или
«авто», и `q` считает 0…9, а `carry` вспыхивает на девятке. «⏸» — пауза: ленту можно утащить
назад и рассмотреть, колесом — масштаб; другие провода добавляются лупой при наведении.

```digitaljs monitor=on
// result: artifact:265e45bc3632c011/circuit.json
// build: hdl-debian13
// Счётчик по модулю 10 с разрешением и переносом — разряд десятичного счётчика
module bcd_counter (
  input  wire       clk,
  input  wire       rst,   // синхронный сброс
  input  wire       en,
  output reg  [3:0] q,
  output wire       carry  // 1 в такте перехода 9 → 0
);
  assign carry = en && (q == 4'd9);
  always @(posedge clk)
    if (rst)        q <= 4'd0;
    else if (carry) q <= 4'd0;
    else if (en)    q <= q + 4'd1;
endmodule
```

## VHDL: светофор на ECP5

Автомат Мура: красный → красный с жёлтым → зелёный → жёлтый. Синтез через GHDL и Yosys под
ECP5-25K.

```hdl
-- result: artifact:4ea2d0d9339d9b3a/schematic.svg
-- build: hdl-debian13
-- Светофор: автомат Мура, длительности фаз — в тактах
library ieee;
use ieee.std_logic_1164.all;

entity traffic is
  port (
    clk, rst           : in  std_logic;
    red, yellow, green : out std_logic
  );
end entity;

architecture rtl of traffic is
  type state_t is (S_RED, S_RED_YELLOW, S_GREEN, S_YELLOW);
  signal state : state_t := S_RED;
  signal timer : natural range 0 to 15 := 0;
begin
  process (clk) begin
    if rising_edge(clk) then
      if rst = '1' then
        state <= S_RED; timer <= 0;
      elsif timer = 0 then
        case state is
          when S_RED        => state <= S_RED_YELLOW; timer <= 2;
          when S_RED_YELLOW => state <= S_GREEN;      timer <= 9;
          when S_GREEN      => state <= S_YELLOW;     timer <= 2;
          when S_YELLOW     => state <= S_RED;        timer <= 9;
        end case;
      else
        timer <= timer - 1;
      end if;
    end if;
  end process;
  red    <= '1' when state = S_RED or state = S_RED_YELLOW else '0';
  yellow <= '1' when state = S_RED_YELLOW or state = S_YELLOW else '0';
  green  <= '1' when state = S_GREEN else '0';
end architecture;
```

```vcd
artifact:6157efe0d8f63f31/wave.vcd
signals: tb_traffic.clk, tb_traffic.red, tb_traffic.yellow, tb_traffic.green, dut.timer
radix: dec
title: Светофор: смена фаз
```

## Временны́е диаграммы вручную: WaveDrom

Каждый знак строки `wave` — такт: `0` `1` — уровни, `.` — без изменений, `=` — значение шины из
`data`, `x` — не определено, `z` — третье состояние, `p` — такт.

## SPI, режим 0

CPOL = 0, CPHA = 0: SCLK в покое низкий, ведомый читает бит по фронту SCLK, ведущий меняет данные по
спаду. Передаётся байт 0xA6 старшим битом вперёд; на бит — два знака строки (низ и верх SCLK).

```wavedrom
{signal: [
  {name: "CS#",  wave: "1.0...................1."},
  {name: "SCLK", wave: "0....1010101010101010..."},
  {name: "MOSI", wave: "x.========x.", period: 2, data: ["1", "0", "1", "0", "0", "1", "1", "0"]},
  {name: "MISO", wave: "zx========xz", period: 2, data: ["D7", "D6", "D5", "D4", "D3", "D2", "D1", "D0"]}
],
 config: {skin: "narrow"},
 head: {text: "SPI, режим 0: байт 0xA6"},
 foot: {text: "MISO в третьем состоянии, пока CS# высокий"}}
```

У MOSI и MISO `period: 2` — знак на бит, два такта SCLK-строки; узкий скин (`narrow`) — чтобы 24
такта поместились в колонку.

## UART 8N1

Линия в покое — единица. Кадр: старт-бит (0), восемь бит данных младшим вперёд, стоп-бит (1). Здесь
передаётся 0x41 — буква «A»: 0100 0001, младшим вперёд — 1, 0, 0, 0, 0, 0, 1, 0.

```wavedrom
{signal: [
  {name: "TX",  wave: "1.010....101."},
  {name: "бит", wave: "x.==========x", data: ["старт", "D0", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "стоп"]}
],
 config: {skin: "narrow", hscale: 2},
 head: {text: "UART 8N1: 0x41 («A»)"}}
```

## AXI-Stream: рукопожатие VALID / READY

Слово передаётся в такте, где одновременно `TVALID = 1` и `TREADY = 1`. Пока приёмник держит
`TREADY = 0`, источник не меняет `TDATA` — слово D2 ждёт три такта.

```wavedrom
{signal: [
  {name: "ACLK",     wave: "p........"},
  {name: "TVALID",   wave: "01.....0."},
  {name: "TREADY",   wave: "1..0..1.."},
  {name: "TDATA",    wave: "x===...x.", data: ["D0", "D1", "D2"]},
  {},
  {name: "передача", wave: "01.0..10."}
],
 head: {text: "AXI-Stream", tick: 0},
 foot: {text: "D2 ждёт TREADY: такты 3–5"}}
```

## Регистр управления

Поля — от младшего бита; IRQ — разрешение прерывания. `attr` — доступ: RW — чтение и запись, RO — только чтение, W1C — сброс
записью единицы.

```wavedrom
{reg: [
  {bits: 1, name: "EN",     attr: "RW"},
  {bits: 2, name: "MODE",   attr: "RW"},
  {bits: 1, name: "IRQ",    attr: "RW"},
  {bits: 4},
  {bits: 8, name: "DIV",    attr: "RW", type: 4},
  {bits: 1, name: "BUSY",   attr: "RO", type: 2},
  {bits: 1, name: "DONE",   attr: "W1C", type: 3},
  {bits: 14}
], config: {lanes: 2, hspace: 720}}
```

## Мультиплексор 2 в 1

`y = s ? b : a` — та же функция вентилями: `(a & ~s) | (b & s)`.

```wavedrom
{assign: [["y", ["|", ["&", "a", ["~", "s"]], ["&", "b", "s"]]]]}
```
