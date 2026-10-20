<!-- Собрано из apps/playground/examples/26-bpmn.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Схемы | теги: bpmn, процесс, медицина, поликлиника, лаборатория, декомпозиция, подпроцесс -->
# BPMN: визит пациента в три уровня

Процесс описан сверху вниз: общая картина с участниками, затем подпроцесс лаборатории,
затем подпроцесс транспортировки проб. На верхнем уровне подпроцесс показан свёрнутым — задачей
с плюсом; ниже он раскрыт отдельной схемой. Так принято декомпозировать процессы в BPMN.

## Уровень 1: визит пациента (совместная работа)

Три участника — пациент, поликлиника с дорожками регистратуры и врача, лаборатория.
Пунктирные стрелки — сообщения между участниками. Координаты и цвета заданы в схеме `bpmndi`:
у каждого участника свой оттенок, шлюзы жёлтые, свёрнутый подпроцесс выделен зелёным.

```bpmn
<?xml version="1.0" encoding="UTF-8"?>
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:bioc="http://bpmn.io/schema/bpmn/biocolor/1.0" xmlns:color="http://www.omg.org/spec/BPMN/non-normative/color/1.0" id="Defs_visit" targetNamespace="spiridus">
  <collaboration id="Collab_visit">
    <participant id="P_patient" name="Пациент" processRef="Proc_patient"/>
    <participant id="P_clinic" name="Поликлиника" processRef="Proc_clinic"/>
    <participant id="P_lab" name="Лаборатория" processRef="Proc_lab"/>
    <messageFlow id="M_a1_sB" name="запись" sourceRef="a1" targetRef="sB"/>
    <messageFlow id="M_a2_b2" name="явка" sourceRef="a2" targetRef="b2"/>
    <messageFlow id="M_b3_sL" name="направление" sourceRef="b3" targetRef="sL"/>
    <messageFlow id="M_a3_l1" name="пробы" sourceRef="a3" targetRef="l1"/>
    <messageFlow id="M_l2_bc" name="результат" sourceRef="l2" targetRef="bc"/>
    <messageFlow id="M_r2_a4" name="уведомление" sourceRef="r2" targetRef="a4"/>
    <messageFlow id="M_a5_b5" name="явка" sourceRef="a5" targetRef="b5"/>
  </collaboration>
  <process id="Proc_patient" isExecutable="false">
    <startEvent id="sA" name="Почувствовал недомогание"/>
    <task id="a1" name="Записаться на приём"/>
    <task id="a2" name="Прийти на приём"/>
    <task id="a3" name="Сдать биоматериал"/>
    <intermediateCatchEvent id="a4" name="Результат получен"><messageEventDefinition id="MED_a4"/></intermediateCatchEvent>
    <task id="a5" name="Прийти на повторный приём"/>
    <endEvent id="eA" name="Лечение назначено"/>
    <sequenceFlow id="F_sA_a1" sourceRef="sA" targetRef="a1"/>
    <sequenceFlow id="F_a1_a2" sourceRef="a1" targetRef="a2"/>
    <sequenceFlow id="F_a2_a3" sourceRef="a2" targetRef="a3"/>
    <sequenceFlow id="F_a3_a4" sourceRef="a3" targetRef="a4"/>
    <sequenceFlow id="F_a4_a5" sourceRef="a4" targetRef="a5"/>
    <sequenceFlow id="F_a5_eA" sourceRef="a5" targetRef="eA"/>
  </process>
  <process id="Proc_clinic" isExecutable="false">
    <laneSet id="LS_P_clinic">
      <lane id="L_reg" name="Регистратура">
        <flowNodeRef>sB</flowNodeRef>
        <flowNodeRef>b1</flowNodeRef>
        <flowNodeRef>r2</flowNodeRef>
      </lane>
      <lane id="L_doc" name="Врач">
        <flowNodeRef>b2</flowNodeRef>
        <flowNodeRef>gB</flowNodeRef>
        <flowNodeRef>b3</flowNodeRef>
        <flowNodeRef>bc</flowNodeRef>
        <flowNodeRef>b5</flowNodeRef>
        <flowNodeRef>eB</flowNodeRef>
      </lane>
    </laneSet>
    <startEvent id="sB" name="Запись получена"><messageEventDefinition id="MED_sB"/></startEvent>
    <task id="b1" name="Оформить запись и талон"/>
    <task id="r2" name="Уведомить пациента"/>
    <task id="b2" name="Осмотр и сбор анамнеза"/>
    <exclusiveGateway id="gB" name="Нужны анализы?"/>
    <task id="b3" name="Выписать направление"/>
    <intermediateCatchEvent id="bc" name="Результат получен"><messageEventDefinition id="MED_bc"/></intermediateCatchEvent>
    <task id="b5" name="Поставить диагноз, назначить лечение"/>
    <endEvent id="eB" name="Приём завершён"/>
    <sequenceFlow id="F_sB_b1" sourceRef="sB" targetRef="b1"/>
    <sequenceFlow id="F_b1_b2" sourceRef="b1" targetRef="b2"/>
    <sequenceFlow id="F_b2_gB" sourceRef="b2" targetRef="gB"/>
    <sequenceFlow id="F_gB_b3" sourceRef="gB" targetRef="b3" name="да"/>
    <sequenceFlow id="F_gB_b5" sourceRef="gB" targetRef="b5" name="нет"/>
    <sequenceFlow id="F_b3_bc" sourceRef="b3" targetRef="bc"/>
    <sequenceFlow id="F_bc_r2" sourceRef="bc" targetRef="r2"/>
    <sequenceFlow id="F_r2_b5" sourceRef="r2" targetRef="b5"/>
    <sequenceFlow id="F_b5_eB" sourceRef="b5" targetRef="eB"/>
  </process>
  <process id="Proc_lab" isExecutable="false">
    <startEvent id="sL" name="Направление получено"><messageEventDefinition id="MED_sL"/></startEvent>
    <subProcess id="l1" name="Лабораторная диагностика"/>
    <task id="l2" name="Отправить результат врачу"/>
    <endEvent id="eL" name="Исследование закрыто"/>
    <sequenceFlow id="F_sL_l1" sourceRef="sL" targetRef="l1"/>
    <sequenceFlow id="F_l1_l2" sourceRef="l1" targetRef="l2"/>
    <sequenceFlow id="F_l2_eL" sourceRef="l2" targetRef="eL"/>
  </process>
  <bpmndi:BPMNDiagram id="BPMNDiagram_visit">
    <bpmndi:BPMNPlane id="Plane_visit" bpmnElement="Collab_visit">
      <bpmndi:BPMNShape id="S_P_patient" bpmnElement="P_patient" isHorizontal="true" bioc:fill="#dbe9ff" bioc:stroke="#2f6fde" color:background-color="#dbe9ff" color:border-color="#2f6fde"><dc:Bounds x="80" y="60" width="1750" height="170"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_P_clinic" bpmnElement="P_clinic" isHorizontal="true" bioc:fill="#fff1dc" bioc:stroke="#b45309" color:background-color="#fff1dc" color:border-color="#b45309"><dc:Bounds x="80" y="270" width="1750" height="340"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_L_reg" bpmnElement="L_reg" isHorizontal="true" bioc:fill="#fff1dc" bioc:stroke="#b45309" color:background-color="#fff1dc" color:border-color="#b45309"><dc:Bounds x="110" y="270" width="1720" height="150"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_L_doc" bpmnElement="L_doc" isHorizontal="true" bioc:fill="#fff8ec" bioc:stroke="#b45309" color:background-color="#fff8ec" color:border-color="#b45309"><dc:Bounds x="110" y="420" width="1720" height="190"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_P_lab" bpmnElement="P_lab" isHorizontal="true" bioc:fill="#dff5e6" bioc:stroke="#2e8b57" color:background-color="#dff5e6" color:border-color="#2e8b57"><dc:Bounds x="80" y="650" width="1750" height="170"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_sA" bpmnElement="sA" bioc:fill="#e3fcec" bioc:stroke="#1f8f4e" color:background-color="#e3fcec" color:border-color="#1f8f4e"><dc:Bounds x="172" y="127" width="36" height="36"/><bpmndi:BPMNLabel><dc:Bounds x="140" y="167" width="100" height="20"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_a1" bpmnElement="a1" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde"><dc:Bounds x="290" y="105" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_a2" bpmnElement="a2" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde"><dc:Bounds x="590" y="105" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_a3" bpmnElement="a3" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde"><dc:Bounds x="1040" y="105" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_a4" bpmnElement="a4" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde"><dc:Bounds x="1372" y="127" width="36" height="36"/><bpmndi:BPMNLabel><dc:Bounds x="1340" y="103" width="100" height="20"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_a5" bpmnElement="a5" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde"><dc:Bounds x="1490" y="105" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_eA" bpmnElement="eA" bioc:fill="#ffe1e1" bioc:stroke="#c0392b" color:background-color="#ffe1e1" color:border-color="#c0392b"><dc:Bounds x="1672" y="127" width="36" height="36"/><bpmndi:BPMNLabel><dc:Bounds x="1640" y="167" width="100" height="20"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_sB" bpmnElement="sB" bioc:fill="#e3fcec" bioc:stroke="#1f8f4e" color:background-color="#e3fcec" color:border-color="#1f8f4e"><dc:Bounds x="322" y="327" width="36" height="36"/><bpmndi:BPMNLabel><dc:Bounds x="290" y="367" width="100" height="20"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_b1" bpmnElement="b1" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309"><dc:Bounds x="440" y="305" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_r2" bpmnElement="r2" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309"><dc:Bounds x="1340" y="305" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_b2" bpmnElement="b2" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309"><dc:Bounds x="590" y="475" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_gB" bpmnElement="gB" bioc:fill="#fff3bf" bioc:stroke="#b8860b" color:background-color="#fff3bf" color:border-color="#b8860b"><dc:Bounds x="765" y="490" width="50" height="50"/><bpmndi:BPMNLabel><dc:Bounds x="740" y="466" width="100" height="20"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_b3" bpmnElement="b3" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309"><dc:Bounds x="890" y="475" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_bc" bpmnElement="bc" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309"><dc:Bounds x="1222" y="497" width="36" height="36"/><bpmndi:BPMNLabel><dc:Bounds x="1190" y="473" width="100" height="20"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_b5" bpmnElement="b5" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309"><dc:Bounds x="1490" y="475" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_eB" bpmnElement="eB" bioc:fill="#ffe1e1" bioc:stroke="#c0392b" color:background-color="#ffe1e1" color:border-color="#c0392b"><dc:Bounds x="1672" y="497" width="36" height="36"/><bpmndi:BPMNLabel><dc:Bounds x="1640" y="537" width="100" height="20"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_sL" bpmnElement="sL" bioc:fill="#e3fcec" bioc:stroke="#1f8f4e" color:background-color="#e3fcec" color:border-color="#1f8f4e"><dc:Bounds x="922" y="717" width="36" height="36"/><bpmndi:BPMNLabel><dc:Bounds x="890" y="757" width="100" height="20"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_l1" bpmnElement="l1" isExpanded="false" bioc:fill="#bfe9cf" bioc:stroke="#2e8b57" color:background-color="#bfe9cf" color:border-color="#2e8b57"><dc:Bounds x="1040" y="695" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_l2" bpmnElement="l2" bioc:fill="#ffffff" bioc:stroke="#2e8b57" color:background-color="#ffffff" color:border-color="#2e8b57"><dc:Bounds x="1190" y="695" width="100" height="80"/></bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="S_eL" bpmnElement="eL" bioc:fill="#ffe1e1" bioc:stroke="#c0392b" color:background-color="#ffe1e1" color:border-color="#c0392b"><dc:Bounds x="1372" y="717" width="36" height="36"/><bpmndi:BPMNLabel><dc:Bounds x="1340" y="757" width="100" height="20"/></bpmndi:BPMNLabel></bpmndi:BPMNShape>
      <bpmndi:BPMNEdge id="E_F_sA_a1" bpmnElement="F_sA_a1" bioc:stroke="#2f6fde" color:border-color="#2f6fde"><di:waypoint x="208" y="145"/><di:waypoint x="290" y="145"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_a1_a2" bpmnElement="F_a1_a2" bioc:stroke="#2f6fde" color:border-color="#2f6fde"><di:waypoint x="390" y="145"/><di:waypoint x="590" y="145"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_a2_a3" bpmnElement="F_a2_a3" bioc:stroke="#2f6fde" color:border-color="#2f6fde"><di:waypoint x="690" y="145"/><di:waypoint x="1040" y="145"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_a3_a4" bpmnElement="F_a3_a4" bioc:stroke="#2f6fde" color:border-color="#2f6fde"><di:waypoint x="1140" y="145"/><di:waypoint x="1372" y="145"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_a4_a5" bpmnElement="F_a4_a5" bioc:stroke="#2f6fde" color:border-color="#2f6fde"><di:waypoint x="1408" y="145"/><di:waypoint x="1490" y="145"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_a5_eA" bpmnElement="F_a5_eA" bioc:stroke="#2f6fde" color:border-color="#2f6fde"><di:waypoint x="1590" y="145"/><di:waypoint x="1672" y="145"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_sB_b1" bpmnElement="F_sB_b1" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="358" y="345"/><di:waypoint x="440" y="345"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_b1_b2" bpmnElement="F_b1_b2" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="540" y="345"/><di:waypoint x="565" y="345"/><di:waypoint x="565" y="515"/><di:waypoint x="590" y="515"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_b2_gB" bpmnElement="F_b2_gB" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="690" y="515"/><di:waypoint x="765" y="515"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_gB_b3" bpmnElement="F_gB_b3" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="815" y="515"/><di:waypoint x="890" y="515"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_gB_b5" bpmnElement="F_gB_b5" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="790" y="540"/><di:waypoint x="790" y="590"/><di:waypoint x="1540" y="590"/><di:waypoint x="1540" y="555"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_b3_bc" bpmnElement="F_b3_bc" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="990" y="515"/><di:waypoint x="1222" y="515"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_bc_r2" bpmnElement="F_bc_r2" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="1258" y="515"/><di:waypoint x="1299" y="515"/><di:waypoint x="1299" y="345"/><di:waypoint x="1340" y="345"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_r2_b5" bpmnElement="F_r2_b5" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="1440" y="345"/><di:waypoint x="1465" y="345"/><di:waypoint x="1465" y="515"/><di:waypoint x="1490" y="515"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_b5_eB" bpmnElement="F_b5_eB" bioc:stroke="#b45309" color:border-color="#b45309"><di:waypoint x="1590" y="515"/><di:waypoint x="1672" y="515"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_sL_l1" bpmnElement="F_sL_l1" bioc:stroke="#2e8b57" color:border-color="#2e8b57"><di:waypoint x="958" y="735"/><di:waypoint x="1040" y="735"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_l1_l2" bpmnElement="F_l1_l2" bioc:stroke="#2e8b57" color:border-color="#2e8b57"><di:waypoint x="1140" y="735"/><di:waypoint x="1190" y="735"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_F_l2_eL" bpmnElement="F_l2_eL" bioc:stroke="#2e8b57" color:border-color="#2e8b57"><di:waypoint x="1290" y="735"/><di:waypoint x="1372" y="735"/></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_M_a1_sB" bpmnElement="M_a1_sB" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a"><di:waypoint x="340" y="185"/><di:waypoint x="340" y="327"/><bpmndi:BPMNLabel><dc:Bounds x="346" y="242" width="80" height="14"/></bpmndi:BPMNLabel></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_M_a2_b2" bpmnElement="M_a2_b2" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a"><di:waypoint x="640" y="185"/><di:waypoint x="640" y="475"/><bpmndi:BPMNLabel><dc:Bounds x="646" y="242" width="80" height="14"/></bpmndi:BPMNLabel></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_M_b3_sL" bpmnElement="M_b3_sL" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a"><di:waypoint x="940" y="555"/><di:waypoint x="940" y="717"/><bpmndi:BPMNLabel><dc:Bounds x="946" y="622" width="80" height="14"/></bpmndi:BPMNLabel></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_M_a3_l1" bpmnElement="M_a3_l1" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a"><di:waypoint x="1090" y="185"/><di:waypoint x="1090" y="695"/><bpmndi:BPMNLabel><dc:Bounds x="1096" y="242" width="80" height="14"/></bpmndi:BPMNLabel></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_M_l2_bc" bpmnElement="M_l2_bc" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a"><di:waypoint x="1240" y="695"/><di:waypoint x="1240" y="533"/><bpmndi:BPMNLabel><dc:Bounds x="1246" y="622" width="80" height="14"/></bpmndi:BPMNLabel></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_M_r2_a4" bpmnElement="M_r2_a4" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a"><di:waypoint x="1390" y="305"/><di:waypoint x="1390" y="163"/><bpmndi:BPMNLabel><dc:Bounds x="1396" y="242" width="80" height="14"/></bpmndi:BPMNLabel></bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="E_M_a5_b5" bpmnElement="M_a5_b5" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a"><di:waypoint x="1540" y="185"/><di:waypoint x="1540" y="475"/><bpmndi:BPMNLabel><dc:Bounds x="1546" y="242" width="80" height="14"/></bpmndi:BPMNLabel></bpmndi:BPMNEdge>
    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>
</definitions>
```

## Уровень 2: лабораторная диагностика

Содержимое свёрнутого подпроцесса из первой схемы. Координат нет — раскладку считает
bpmn-auto-layout прямо во фрейме; внутри — ещё один свёрнутый подпроцесс.

```bpmn
<?xml version="1.0" encoding="UTF-8"?>
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" id="Defs_lab" targetNamespace="spiridus">
  <process id="Proc_labdiag" name="Лабораторная диагностика" isExecutable="false">
    <startEvent id="ls" name="Направление получено"><messageEventDefinition id="MED_ls"/></startEvent>
    <sequenceFlow id="lf1" sourceRef="ls" targetRef="lt1"/>
    <task id="lt1" name="Забор биоматериала"/>
    <sequenceFlow id="lf2" sourceRef="lt1" targetRef="lt2"/>
    <task id="lt2" name="Маркировка пробирок"/>
    <sequenceFlow id="lf3" sourceRef="lt2" targetRef="lsub"/>
    <subProcess id="lsub" name="Транспортировка проб"/>
    <sequenceFlow id="lf4" sourceRef="lsub" targetRef="lt3"/>
    <task id="lt3" name="Регистрация в ЛИС"/>
    <sequenceFlow id="lf5" sourceRef="lt3" targetRef="lg"/>
    <exclusiveGateway id="lg"/>
    <sequenceFlow id="lf6" sourceRef="lg" targetRef="lt4" name="проба годна"/>
    <sequenceFlow id="lf7" sourceRef="lg" targetRef="lt6" name="брак"/>
    <task id="lt4" name="Анализ на анализаторе"/>
    <sequenceFlow id="lf8" sourceRef="lt4" targetRef="lt5"/>
    <task id="lt5" name="Валидация врачом КЛД"/>
    <sequenceFlow id="lf9" sourceRef="lt5" targetRef="le1"/>
    <endEvent id="le1" name="Результат передан"><messageEventDefinition id="MED_le1"/></endEvent>
    <task id="lt6" name="Повторный забор"/>
    <sequenceFlow id="lf10" sourceRef="lt6" targetRef="le2"/>
    <endEvent id="le2" name="Пациент приглашён повторно"/>
  </process>
</definitions>
```

## Уровень 3: транспортировка проб

```bpmn
<?xml version="1.0" encoding="UTF-8"?>
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" id="Defs_transport" targetNamespace="spiridus">
  <process id="Proc_transport" name="Транспортировка проб" isExecutable="false">
    <startEvent id="ts" name="Пробы промаркированы"/>
    <sequenceFlow id="tf1" sourceRef="ts" targetRef="tt1"/>
    <task id="tt1" name="Упаковать в термоконтейнер"/>
    <sequenceFlow id="tf2" sourceRef="tt1" targetRef="tt2"/>
    <task id="tt2" name="Запись в журнал передачи"/>
    <sequenceFlow id="tf3" sourceRef="tt2" targetRef="tt3"/>
    <task id="tt3" name="Передать курьеру под подпись"/>
    <sequenceFlow id="tf4" sourceRef="tt3" targetRef="tt4"/>
    <task id="tt4" name="Доставить за 2 часа"/>
    <sequenceFlow id="tf5" sourceRef="tt4" targetRef="tt5"/>
    <task id="tt5" name="Проверка при приёмке"/>
    <sequenceFlow id="tf6" sourceRef="tt5" targetRef="tg"/>
    <exclusiveGateway id="tg"/>
    <sequenceFlow id="tf7" sourceRef="tg" targetRef="tt6" name="в норме"/>
    <sequenceFlow id="tf8" sourceRef="tg" targetRef="tt7" name="нарушения"/>
    <task id="tt6" name="Принять в работу"/>
    <sequenceFlow id="tf9" sourceRef="tt6" targetRef="te1"/>
    <endEvent id="te1" name="Пробы в лаборатории"/>
    <task id="tt7" name="Акт и повторный забор"/>
    <sequenceFlow id="tf10" sourceRef="tt7" targetRef="te2"/>
    <endEvent id="te2" name="Пробы забракованы"/>
  </process>
</definitions>
```

## Ошибка

Незакрытый тег — ошибка разбора с объяснением под исходником:

```bpmn
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" id="x">
  <process id="p"><userTask id="t" name="Незакрытая задача"></process>
</definitions>
```
