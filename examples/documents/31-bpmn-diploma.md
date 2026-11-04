<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Схемы | теги: bpmn, процесс, дорожки, юмор, диплом, вуз -->
# BPMN: как выбрать тему диплома

Шуточный процесс: один пул «Выбор темы диплома» и четыре дорожки — студент, чат @ntwrk, научный
руководитель-собачник и вуз. Цвета дорожек и подписи заданы в схеме `bpmndi`: вопрос шлюза
вынесен в подписи ветвей. Дорожки идут одна под другой, внутри шаги расположены вертикально;
подписи событий стоят сбоку от потока, длинные переходы обходят дорожки справа.

```bpmn
<?xml version="1.0" encoding="UTF-8"?>
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bioc="http://bpmn.io/schema/bpmn/biocolor/1.0" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:color="http://www.omg.org/spec/BPMN/non-normative/color/1.0" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Defs_diploma" targetNamespace="spiridus">
  <collaboration id="Collab_diploma">
    <participant id="P_diploma" name="Выбор темы диплома" processRef="Proc_diploma" />
  </collaboration>
  <process id="Proc_diploma" isExecutable="false">
    <laneSet id="LS_diploma">
      <lane id="L_st" name="Студент">
        <flowNodeRef>s</flowNodeRef>
        <flowNodeRef>t1</flowNodeRef>
        <flowNodeRef>t3</flowNodeRef>
        <flowNodeRef>t6</flowNodeRef>
        <flowNodeRef>e</flowNodeRef>
      </lane>
      <lane id="L_chat" name="Чат @ntwrk">
        <flowNodeRef>t2</flowNodeRef>
        <flowNodeRef>t7</flowNodeRef>
      </lane>
      <lane id="L_sup" name="Руководитель (собачник)">
        <flowNodeRef>t4</flowNodeRef>
        <flowNodeRef>g</flowNodeRef>
        <flowNodeRef>t5</flowNodeRef>
        <flowNodeRef>t8</flowNodeRef>
      </lane>
      <lane id="L_uni" name="Вуз">
        <flowNodeRef>t9</flowNodeRef>
      </lane>
    </laneSet>
    <startEvent id="s" name="Пора выбирать тему" />
    <task id="t1" name="Спросить в чате @ntwrk" />
    <task id="t2" name="Насоветовать EVPN, Kubernetes и «просто свою LLM»" />
    <task id="t3" name="Выбрать самую хайповую тему" />
    <task id="t4" name="Посмотреть на тему поверх очков" />
    <exclusiveGateway id="g" />
    <task id="t5" name="Рассказать про своего корги 40 минут" />
    <task id="t6" name="Добавить в тему собак" />
    <task id="t7" name="Ответить «норм, но есть нюанс»" />
    <task id="t8" name="Одобрить с улыбкой" />
    <task id="t9" name="Утвердить приказом через полгода" />
    <endEvent id="e" name="Тема: «Мониторинг сети собачьих приютов на EVPN»" />
    <sequenceFlow id="F_s_t1" sourceRef="s" targetRef="t1" />
    <sequenceFlow id="F_t1_t2" sourceRef="t1" targetRef="t2" />
    <sequenceFlow id="F_t2_t3" sourceRef="t2" targetRef="t3" />
    <sequenceFlow id="F_t3_t4" sourceRef="t3" targetRef="t4" />
    <sequenceFlow id="F_t4_g" sourceRef="t4" targetRef="g" />
    <sequenceFlow id="F_g_t5" sourceRef="g" targetRef="t5" name="собак нет" />
    <sequenceFlow id="F_g_t8" sourceRef="g" targetRef="t8" name="про собак" />
    <sequenceFlow id="F_t5_t6" sourceRef="t5" targetRef="t6" />
    <sequenceFlow id="F_t6_t7" sourceRef="t6" targetRef="t7" />
    <sequenceFlow id="F_t7_t8" sourceRef="t7" targetRef="t8" />
    <sequenceFlow id="F_t8_t9" sourceRef="t8" targetRef="t9" />
    <sequenceFlow id="F_t9_e" sourceRef="t9" targetRef="e" />
  </process>
  <bpmndi:BPMNDiagram id="Diagram_Defs_diploma">
    <bpmndi:BPMNPlane id="Plane_Defs_diploma" bpmnElement="Collab_diploma">
      <bpmndi:BPMNShape id="Shape_P_diploma" bpmnElement="P_diploma" isHorizontal="true">
        <dc:Bounds x="20" y="20" width="290" height="2048" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_L_st" bpmnElement="L_st" bioc:fill="#dbe9ff" bioc:stroke="#2f6fde" color:background-color="#dbe9ff" color:border-color="#2f6fde" isHorizontal="true">
        <dc:Bounds x="50" y="20" width="260" height="807" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_L_chat" bpmnElement="L_chat" bioc:fill="#efe3ff" bioc:stroke="#7b3fbf" color:background-color="#efe3ff" color:border-color="#7b3fbf" isHorizontal="true">
        <dc:Bounds x="50" y="827" width="260" height="366" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_L_sup" bpmnElement="L_sup" bioc:fill="#fff1dc" bioc:stroke="#b45309" color:background-color="#fff1dc" color:border-color="#b45309" isHorizontal="true">
        <dc:Bounds x="50" y="1193" width="260" height="692" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_L_uni" bpmnElement="L_uni" bioc:fill="#dff5e6" bioc:stroke="#2e8b57" color:background-color="#dff5e6" color:border-color="#2e8b57" isHorizontal="true">
        <dc:Bounds x="50" y="1885" width="260" height="183" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_s" bpmnElement="s" bioc:fill="#e3fcec" bioc:stroke="#1f8f4e" color:background-color="#e3fcec" color:border-color="#1f8f4e">
        <dc:Bounds x="170.0" y="58" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="55" y="54" width="100" height="55" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_t1" bpmnElement="t1" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde">
        <dc:Bounds x="123.0" y="187" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_t3" bpmnElement="t3" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde">
        <dc:Bounds x="123.0" y="370" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_t6" bpmnElement="t6" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde">
        <dc:Bounds x="123.0" y="553" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_e" bpmnElement="e" bioc:fill="#ffe1e1" bioc:stroke="#c0392b" color:background-color="#ffe1e1" color:border-color="#c0392b">
        <dc:Bounds x="170.0" y="736" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="55" y="732" width="100" height="55" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_t2" bpmnElement="t2" bioc:fill="#ffffff" bioc:stroke="#7b3fbf" color:background-color="#ffffff" color:border-color="#7b3fbf">
        <dc:Bounds x="123.0" y="865" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_t7" bpmnElement="t7" bioc:fill="#ffffff" bioc:stroke="#7b3fbf" color:background-color="#ffffff" color:border-color="#7b3fbf">
        <dc:Bounds x="123.0" y="1048" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_t4" bpmnElement="t4" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309">
        <dc:Bounds x="123.0" y="1231" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_g" bpmnElement="g" bioc:fill="#fff3bf" bioc:stroke="#b8860b" color:background-color="#fff3bf" color:border-color="#b8860b">
        <dc:Bounds x="163.0" y="1414" width="50" height="50" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_t5" bpmnElement="t5" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309">
        <dc:Bounds x="123.0" y="1557" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_t8" bpmnElement="t8" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309">
        <dc:Bounds x="123.0" y="1740" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_t9" bpmnElement="t9" bioc:fill="#ffffff" bioc:stroke="#2e8b57" color:background-color="#ffffff" color:border-color="#2e8b57">
        <dc:Bounds x="123.0" y="1923" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNEdge id="Edge_F_s_t1" bpmnElement="F_s_t1" bioc:stroke="#2f6fde" color:border-color="#2f6fde">
        <di:waypoint x="188.0" y="94" />
        <di:waypoint x="188.0" y="187" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_t1_t2" bpmnElement="F_t1_t2" bioc:stroke="#2f6fde" color:border-color="#2f6fde">
        <di:waypoint x="253.0" y="232.0" />
        <di:waypoint x="342" y="232.0" />
        <di:waypoint x="342" y="910.0" />
        <di:waypoint x="253.0" y="910.0" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_t2_t3" bpmnElement="F_t2_t3" bioc:stroke="#7b3fbf" color:border-color="#7b3fbf">
        <di:waypoint x="253.0" y="910.0" />
        <di:waypoint x="354" y="910.0" />
        <di:waypoint x="354" y="415.0" />
        <di:waypoint x="253.0" y="415.0" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_t3_t4" bpmnElement="F_t3_t4" bioc:stroke="#2f6fde" color:border-color="#2f6fde">
        <di:waypoint x="253.0" y="415.0" />
        <di:waypoint x="330" y="415.0" />
        <di:waypoint x="330" y="1276.0" />
        <di:waypoint x="253.0" y="1276.0" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_t4_g" bpmnElement="F_t4_g" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="188.0" y="1321" />
        <di:waypoint x="188.0" y="1414" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_g_t5" bpmnElement="F_g_t5" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="188.0" y="1464" />
        <di:waypoint x="188.0" y="1557" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="218" y="1476.0" width="100" height="30" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_g_t8" bpmnElement="F_g_t8" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="213.0" y="1439.0" />
        <di:waypoint x="330" y="1439.0" />
        <di:waypoint x="330" y="1785.0" />
        <di:waypoint x="253.0" y="1785.0" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="218" y="1510.0" width="100" height="30" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_t5_t6" bpmnElement="F_t5_t6" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="253.0" y="1602.0" />
        <di:waypoint x="342" y="1602.0" />
        <di:waypoint x="342" y="598.0" />
        <di:waypoint x="253.0" y="598.0" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_t6_t7" bpmnElement="F_t6_t7" bioc:stroke="#2f6fde" color:border-color="#2f6fde">
        <di:waypoint x="253.0" y="598.0" />
        <di:waypoint x="354" y="598.0" />
        <di:waypoint x="354" y="1093.0" />
        <di:waypoint x="253.0" y="1093.0" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_t7_t8" bpmnElement="F_t7_t8" bioc:stroke="#7b3fbf" color:border-color="#7b3fbf">
        <di:waypoint x="253.0" y="1093.0" />
        <di:waypoint x="330" y="1093.0" />
        <di:waypoint x="330" y="1785.0" />
        <di:waypoint x="253.0" y="1785.0" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_t8_t9" bpmnElement="F_t8_t9" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="188.0" y="1830" />
        <di:waypoint x="188.0" y="1923" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_t9_e" bpmnElement="F_t9_e" bioc:stroke="#2e8b57" color:border-color="#2e8b57">
        <di:waypoint x="253.0" y="1968.0" />
        <di:waypoint x="354" y="1968.0" />
        <di:waypoint x="354" y="754.0" />
        <di:waypoint x="206.0" y="754.0" />
      </bpmndi:BPMNEdge>
    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>
</definitions>
```

Мораль процесса: любая тема сходится к собакам — вопрос только в том, сколько минут про корги вы
выслушаете по дороге.
