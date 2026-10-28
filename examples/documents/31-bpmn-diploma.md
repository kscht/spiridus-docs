<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Схемы | теги: bpmn, процесс, дорожки, юмор, диплом, вуз -->
# BPMN: как выбрать тему диплома

Шуточный процесс: один пул «Выбор темы диплома» и четыре дорожки — студент, чат @ntwrk, научный
руководитель-собачник и вуз. Цвета дорожек и подписи заданы в схеме `bpmndi`: вопрос шлюза
вынесен в подписи ветвей, подписи событий — под кружками с зазором, связи между дорожками —
уступом, ветвь «про собак» обходит рассказ про корги по дорожке вуза.

```bpmn
<?xml version="1.0" encoding="UTF-8"?>
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:bioc="http://bpmn.io/schema/bpmn/biocolor/1.0" xmlns:color="http://www.omg.org/spec/BPMN/non-normative/color/1.0" id="Defs_diploma" targetNamespace="spiridus">
  <collaboration id="Collab_diploma">
    <participant id="P_diploma" name="Выбор темы диплома" processRef="Proc_diploma"/>
  </collaboration>
  <process id="Proc_diploma" isExecutable="false">
    <laneSet id="LS_diploma">
      <lane id="L_st" name="Студент"><flowNodeRef>s</flowNodeRef><flowNodeRef>t1</flowNodeRef><flowNodeRef>t3</flowNodeRef><flowNodeRef>t6</flowNodeRef><flowNodeRef>e</flowNodeRef></lane>
      <lane id="L_chat" name="Чат @ntwrk"><flowNodeRef>t2</flowNodeRef><flowNodeRef>t7</flowNodeRef></lane>
      <lane id="L_sup" name="Руководитель (собачник)"><flowNodeRef>t4</flowNodeRef><flowNodeRef>g</flowNodeRef><flowNodeRef>t5</flowNodeRef><flowNodeRef>t8</flowNodeRef></lane>
      <lane id="L_uni" name="Вуз"><flowNodeRef>t9</flowNodeRef></lane>
    </laneSet>
    <startEvent id="s" name="Пора выбирать тему"/>
    <task id="t1" name="Спросить в чате @ntwrk"/>
    <task id="t2" name="Насоветовать EVPN, Kubernetes и «просто свою LLM»"/>
    <task id="t3" name="Выбрать самую хайповую тему"/>
    <task id="t4" name="Посмотреть на тему поверх очков"/>
    <exclusiveGateway id="g"/>
    <task id="t5" name="Рассказать про своего корги 40 минут"/>
    <task id="t6" name="Добавить в тему собак"/>
    <task id="t7" name="Ответить «норм, но есть нюанс»"/>
    <task id="t8" name="Одобрить с улыбкой"/>
    <task id="t9" name="Утвердить приказом через полгода"/>
    <endEvent id="e" name="Тема: «Мониторинг сети собачьих приютов на EVPN»"/>
    <sequenceFlow id="F_s_t1" sourceRef="s" targetRef="t1"/>
    <sequenceFlow id="F_t1_t2" sourceRef="t1" targetRef="t2"/>
    <sequenceFlow id="F_t2_t3" sourceRef="t2" targetRef="t3"/>
    <sequenceFlow id="F_t3_t4" sourceRef="t3" targetRef="t4"/>
    <sequenceFlow id="F_t4_g" sourceRef="t4" targetRef="g"/>
    <sequenceFlow id="F_g_t5" sourceRef="g" targetRef="t5" name="собак нет"/>
    <sequenceFlow id="F_g_t8" sourceRef="g" targetRef="t8" name="про собак"/>
    <sequenceFlow id="F_t5_t6" sourceRef="t5" targetRef="t6"/>
    <sequenceFlow id="F_t6_t7" sourceRef="t6" targetRef="t7"/>
    <sequenceFlow id="F_t7_t8" sourceRef="t7" targetRef="t8"/>
    <sequenceFlow id="F_t8_t9" sourceRef="t8" targetRef="t9"/>
    <sequenceFlow id="F_t9_e" sourceRef="t9" targetRef="e"/>
  </process>
  <bpmndi:BPMNDiagram id="BPMNDiagram_diploma">
    <bpmndi:BPMNPlane id="Plane_diploma" bpmnElement="Collab_diploma">
      <bpmndi:BPMNShape id="S_P_diploma" bpmnElement="P_diploma" isHorizontal="true"><dc:Bounds x="60" y="40" width="1900" height="600"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_L_st" bpmnElement="L_st" isHorizontal="true" bioc:fill="#dbe9ff" bioc:stroke="#2f6fde" color:background-color="#dbe9ff" color:border-color="#2f6fde"><dc:Bounds x="90" y="40" width="1870" height="150"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_L_chat" bpmnElement="L_chat" isHorizontal="true" bioc:fill="#efe3ff" bioc:stroke="#7b3fbf" color:background-color="#efe3ff" color:border-color="#7b3fbf"><dc:Bounds x="90" y="190" width="1870" height="150"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_L_sup" bpmnElement="L_sup" isHorizontal="true" bioc:fill="#fff1dc" bioc:stroke="#b45309" color:background-color="#fff1dc" color:border-color="#b45309"><dc:Bounds x="90" y="340" width="1870" height="150"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_L_uni" bpmnElement="L_uni" isHorizontal="true" bioc:fill="#dff5e6" bioc:stroke="#2e8b57" color:background-color="#dff5e6" color:border-color="#2e8b57"><dc:Bounds x="90" y="490" width="1870" height="150"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_s" bpmnElement="s" bioc:fill="#e3fcec" bioc:stroke="#1f8f4e" color:background-color="#e3fcec" color:border-color="#1f8f4e"><dc:Bounds x="162" y="97" width="36" height="36"/><bpmndi:BPMNLabel><dc:Bounds x="120" y="141" width="120" height="28"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_t1" bpmnElement="t1" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde"><dc:Bounds x="275" y="75" width="110" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_t2" bpmnElement="t2" bioc:fill="#ffffff" bioc:stroke="#7b3fbf" color:background-color="#ffffff" color:border-color="#7b3fbf"><dc:Bounds x="425" y="225" width="110" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_t3" bpmnElement="t3" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde"><dc:Bounds x="575" y="75" width="110" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_t4" bpmnElement="t4" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309"><dc:Bounds x="725" y="375" width="110" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_g" bpmnElement="g" bioc:fill="#fff3bf" bioc:stroke="#b8860b" color:background-color="#fff3bf" color:border-color="#b8860b"><dc:Bounds x="905" y="390" width="50" height="50"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_t5" bpmnElement="t5" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309"><dc:Bounds x="1025" y="375" width="110" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_t6" bpmnElement="t6" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde"><dc:Bounds x="1175" y="75" width="110" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_t7" bpmnElement="t7" bioc:fill="#ffffff" bioc:stroke="#7b3fbf" color:background-color="#ffffff" color:border-color="#7b3fbf"><dc:Bounds x="1325" y="225" width="110" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_t8" bpmnElement="t8" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309"><dc:Bounds x="1475" y="375" width="110" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_t9" bpmnElement="t9" bioc:fill="#ffffff" bioc:stroke="#2e8b57" color:background-color="#ffffff" color:border-color="#2e8b57"><dc:Bounds x="1625" y="525" width="110" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_e" bpmnElement="e" bioc:fill="#ffe1e1" bioc:stroke="#c0392b" color:background-color="#ffe1e1" color:border-color="#c0392b"><dc:Bounds x="1812" y="97" width="36" height="36"/><bpmndi:BPMNLabel><dc:Bounds x="1770" y="141" width="120" height="42"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNEdge id="E_s_t1" bpmnElement="F_s_t1" bioc:stroke="#2f6fde" color:border-color="#2f6fde"><di:waypoint x="198" y="115"/><di:waypoint x="275" y="115"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_t1_t2" bpmnElement="F_t1_t2" bioc:stroke="#2f6fde" color:border-color="#2f6fde"><di:waypoint x="385" y="115"/><di:waypoint x="405" y="115"/><di:waypoint x="405" y="265"/><di:waypoint x="425" y="265"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_t2_t3" bpmnElement="F_t2_t3" bioc:stroke="#7b3fbf" color:border-color="#7b3fbf"><di:waypoint x="535" y="265"/><di:waypoint x="555" y="265"/><di:waypoint x="555" y="115"/><di:waypoint x="575" y="115"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_t3_t4" bpmnElement="F_t3_t4" bioc:stroke="#2f6fde" color:border-color="#2f6fde"><di:waypoint x="685" y="115"/><di:waypoint x="705" y="115"/><di:waypoint x="705" y="415"/><di:waypoint x="725" y="415"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_t4_g" bpmnElement="F_t4_g" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="835" y="415"/><di:waypoint x="905" y="415"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_g_t5" bpmnElement="F_g_t5" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="955" y="415"/><di:waypoint x="1025" y="415"/><bpmndi:BPMNLabel><dc:Bounds x="963" y="393" width="71" height="14"/></bpmndi:BPMNLabel></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_g_t8" bpmnElement="F_g_t8" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="930" y="440"/><di:waypoint x="930" y="518"/><di:waypoint x="1530" y="518"/><di:waypoint x="1530" y="455"/><bpmndi:BPMNLabel><dc:Bounds x="938" y="450" width="71" height="14"/></bpmndi:BPMNLabel></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_t5_t6" bpmnElement="F_t5_t6" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="1135" y="415"/><di:waypoint x="1155" y="415"/><di:waypoint x="1155" y="115"/><di:waypoint x="1175" y="115"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_t6_t7" bpmnElement="F_t6_t7" bioc:stroke="#2f6fde" color:border-color="#2f6fde"><di:waypoint x="1285" y="115"/><di:waypoint x="1305" y="115"/><di:waypoint x="1305" y="265"/><di:waypoint x="1325" y="265"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_t7_t8" bpmnElement="F_t7_t8" bioc:stroke="#7b3fbf" color:border-color="#7b3fbf"><di:waypoint x="1435" y="265"/><di:waypoint x="1455" y="265"/><di:waypoint x="1455" y="415"/><di:waypoint x="1475" y="415"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_t8_t9" bpmnElement="F_t8_t9" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="1585" y="415"/><di:waypoint x="1605" y="415"/><di:waypoint x="1605" y="565"/><di:waypoint x="1625" y="565"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_t9_e" bpmnElement="F_t9_e" bioc:stroke="#2e8b57" color:border-color="#2e8b57"><di:waypoint x="1735" y="565"/><di:waypoint x="1774" y="565"/><di:waypoint x="1774" y="115"/><di:waypoint x="1812" y="115"/></bpmndi:BPMNEdge>
    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>
</definitions>
```

Мораль процесса: любая тема сходится к собакам — вопрос только в том, сколько минут про корги вы
выслушаете по дороге.
