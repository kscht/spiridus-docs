<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Схемы | теги: bpmn, процесс, медицина, поликлиника, лаборатория, декомпозиция, подпроцесс -->
# BPMN: визит пациента в три уровня

Процесс описан сверху вниз: общая картина с участниками, затем подпроцесс лаборатории,
затем подпроцесс транспортировки проб. На верхнем уровне вызов процесса показан задачей
с толстой рамкой (`callActivity`); нажатие открывает вызываемый процесс. Так принято декомпозировать процессы в BPMN.

Схемы без `build=` показываются собственным SVG-просмотрщиком. Для прежнего вида
можно явно указать `build=bpmn-auto-2.0.0-alpha.2`.

## Уровень 1: визит пациента (совместная работа)

Три участника — пациент, поликлиника с дорожками регистратуры и врача, лаборатория.
Пунктирные стрелки — сообщения между участниками. Координаты и цвета заданы в схеме `bpmndi` и сохраняются режимом `di=exact`:
у каждого участника свой оттенок, шлюзы жёлтые, вызов процесса выделен зелёным.
Сообщение о повторной явке адресовано пулу поликлиники; ромб перед назначением лечения
сливает только альтернативные потоки процесса.

```bpmn di=exact
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bioc="http://bpmn.io/schema/bpmn/biocolor/1.0" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:color="http://www.omg.org/spec/BPMN/non-normative/color/1.0" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Defs_visit" targetNamespace="spiridus">
  <collaboration id="Collab_visit">
    <participant id="P_patient" name="Пациент" processRef="Proc_patient" />
    <participant id="P_clinic" name="Поликлиника" processRef="Proc_clinic" />
    <participant id="P_lab" name="Лаборатория" processRef="Proc_lab" />
    <messageFlow id="M_a1_sB" name="запись" sourceRef="a1" targetRef="sB" />
    <messageFlow id="M_a2_b2" name="явка" sourceRef="a2" targetRef="b2" />
    <messageFlow id="M_b3_sL" name="направление" sourceRef="b3" targetRef="sL" />
    <messageFlow id="M_a3_l1" name="пробы" sourceRef="a3" targetRef="l1" />
    <messageFlow id="M_l2_bc" name="результат" sourceRef="l2" targetRef="bc" />
    <messageFlow id="M_r2_a4" name="уведомление" sourceRef="r2" targetRef="a4" />
    <messageFlow id="M_a5_b5" name="явка" sourceRef="a5" targetRef="P_clinic" />
  </collaboration>
  <process id="Proc_patient" isExecutable="false">
    <startEvent id="sA" name="Почувствовал недомогание" />
    <task id="a1" name="Записаться на приём" />
    <task id="a2" name="Прийти на приём" />
    <task id="a3" name="Сдать биоматериал" />
    <intermediateCatchEvent id="a4" name="Результат получен">
      <messageEventDefinition id="MED_a4" />
    </intermediateCatchEvent>
    <task id="a5" name="Прийти на повторный приём" />
    <endEvent id="eA" name="Лечение назначено" />
    <sequenceFlow id="F_sA_a1" sourceRef="sA" targetRef="a1" />
    <sequenceFlow id="F_a1_a2" sourceRef="a1" targetRef="a2" />
    <sequenceFlow id="F_a2_a3" sourceRef="a2" targetRef="a3" />
    <sequenceFlow id="F_a3_a4" sourceRef="a3" targetRef="a4" />
    <sequenceFlow id="F_a4_a5" sourceRef="a4" targetRef="a5" />
    <sequenceFlow id="F_a5_eA" sourceRef="a5" targetRef="eA" />
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
        <flowNodeRef>Join_visit</flowNodeRef>
        <flowNodeRef>b5</flowNodeRef>
        <flowNodeRef>eB</flowNodeRef>
      </lane>
    </laneSet>
    <startEvent id="sB" name="Запись получена">
      <messageEventDefinition id="MED_sB" />
    </startEvent>
    <task id="b1" name="Оформить запись и талон" />
    <task id="r2" name="Уведомить пациента" />
    <task id="b2" name="Осмотр и сбор анамнеза" />
    <exclusiveGateway id="gB" name="Нужны анализы?" />
    <task id="b3" name="Выписать направление" />
    <intermediateCatchEvent id="bc" name="Результат получен">
      <messageEventDefinition id="MED_bc" />
    </intermediateCatchEvent>
    <exclusiveGateway id="Join_visit" />
    <task id="b5" name="Поставить диагноз, назначить лечение" />
    <endEvent id="eB" name="Приём завершён" />
    <sequenceFlow id="F_sB_b1" sourceRef="sB" targetRef="b1" />
    <sequenceFlow id="F_b1_b2" sourceRef="b1" targetRef="b2" />
    <sequenceFlow id="F_b2_gB" sourceRef="b2" targetRef="gB" />
    <sequenceFlow id="F_gB_b3" sourceRef="gB" targetRef="b3" name="да" />
    <sequenceFlow id="F_gB_b5" sourceRef="gB" targetRef="Join_visit" name="нет" />
    <sequenceFlow id="F_b3_bc" sourceRef="b3" targetRef="bc" />
    <sequenceFlow id="F_bc_r2" sourceRef="bc" targetRef="r2" />
    <sequenceFlow id="F_r2_b5" sourceRef="r2" targetRef="Join_visit" />
    <sequenceFlow id="F_join_b5" sourceRef="Join_visit" targetRef="b5" />
    <sequenceFlow id="F_b5_eB" sourceRef="b5" targetRef="eB" />
  </process>
  <process id="Proc_lab" isExecutable="false">
    <startEvent id="sL" name="Направление получено">
      <messageEventDefinition id="MED_sL" />
    </startEvent>
    <callActivity id="l1" name="Лабораторная диагностика" calledElement="Proc_labdiag" />
    <task id="l2" name="Отправить результат врачу" />
    <endEvent id="eL" name="Исследование закрыто" />
    <sequenceFlow id="F_sL_l1" sourceRef="sL" targetRef="l1" />
    <sequenceFlow id="F_l1_l2" sourceRef="l1" targetRef="l2" />
    <sequenceFlow id="F_l2_eL" sourceRef="l2" targetRef="eL" />
  </process>
  <bpmndi:BPMNDiagram id="Diagram_Defs_visit">
    <bpmndi:BPMNPlane id="Plane_Defs_visit" bpmnElement="Collab_visit">
      <bpmndi:BPMNShape id="Shape_P_patient" bpmnElement="P_patient" bioc:fill="#dbe9ff" bioc:stroke="#2f6fde" color:background-color="#dbe9ff" color:border-color="#2f6fde" isHorizontal="true">
        <dc:Bounds x="40" y="80" width="5200" height="320" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_P_clinic" bpmnElement="P_clinic" bioc:fill="#fff1dc" bioc:stroke="#b45309" color:background-color="#fff1dc" color:border-color="#b45309" isHorizontal="true">
        <dc:Bounds x="40" y="480" width="5200" height="640" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_L_reg" bpmnElement="L_reg" bioc:fill="#fff1dc" bioc:stroke="#b45309" color:background-color="#fff1dc" color:border-color="#b45309" isHorizontal="true">
        <dc:Bounds x="100" y="480" width="5140" height="320" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_L_doc" bpmnElement="L_doc" bioc:fill="#fff8ec" bioc:stroke="#b45309" color:background-color="#fff8ec" color:border-color="#b45309" isHorizontal="true">
        <dc:Bounds x="100" y="800" width="5140" height="320" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_P_lab" bpmnElement="P_lab" bioc:fill="#dff5e6" bioc:stroke="#2e8b57" color:background-color="#dff5e6" color:border-color="#2e8b57" isHorizontal="true">
        <dc:Bounds x="40" y="1200" width="5200" height="320" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_sA" bpmnElement="sA" bioc:fill="#e3fcec" bioc:stroke="#1f8f4e" color:background-color="#e3fcec" color:border-color="#1f8f4e">
        <dc:Bounds x="262" y="182" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="228.826171875" y="234" width="102.34765625" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_a1" bpmnElement="a1" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde">
        <dc:Bounds x="495" y="155" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_a2" bpmnElement="a2" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde">
        <dc:Bounds x="775" y="155" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_a3" bpmnElement="a3" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde">
        <dc:Bounds x="1055" y="155" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_a4" bpmnElement="a4" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde">
        <dc:Bounds x="3622" y="182" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="3602.56298828125" y="234" width="74.8740234375" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_a5" bpmnElement="a5" bioc:fill="#ffffff" bioc:stroke="#2f6fde" color:background-color="#ffffff" color:border-color="#2f6fde">
        <dc:Bounds x="3855" y="155" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_eA" bpmnElement="eA" bioc:fill="#ffe1e1" bioc:stroke="#c0392b" color:background-color="#ffe1e1" color:border-color="#c0392b">
        <dc:Bounds x="4182" y="182" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="4161.24365234375" y="234" width="77.5126953125" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_sB" bpmnElement="sB" bioc:fill="#e3fcec" bioc:stroke="#1f8f4e" color:background-color="#e3fcec" color:border-color="#1f8f4e">
        <dc:Bounds x="822" y="582" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="805.21533203125" y="634" width="69.5693359375" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_b1" bpmnElement="b1" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309">
        <dc:Bounds x="1055" y="555" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_r2" bpmnElement="r2" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309">
        <dc:Bounds x="4975" y="555" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_b2" bpmnElement="b2" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309">
        <dc:Bounds x="1335" y="875" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_gB" bpmnElement="gB" bioc:fill="#fff3bf" bioc:stroke="#b8860b" color:background-color="#fff3bf" color:border-color="#b8860b">
        <dc:Bounds x="1655" y="895" width="50" height="50" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="1644.8564453125" y="961" width="70.287109375" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_b3" bpmnElement="b3" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309">
        <dc:Bounds x="1895" y="875" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_bc" bpmnElement="bc" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309">
        <dc:Bounds x="3062" y="902" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="3114.56298828125" y="954" width="74.8740234375" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_Join_visit" bpmnElement="Join_visit">
        <dc:Bounds x="4175" y="895" width="50" height="50" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNEdge id="Edge_F_join_b5" bpmnElement="F_join_b5">
        <di:waypoint x="4225" y="920" />
        <di:waypoint x="4415" y="920" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNShape id="Shape_b5" bpmnElement="b5" bioc:fill="#ffffff" bioc:stroke="#b45309" color:background-color="#ffffff" color:border-color="#b45309">
        <dc:Bounds x="4415" y="875" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_eB" bpmnElement="eB" bioc:fill="#ffe1e1" bioc:stroke="#c0392b" color:background-color="#ffe1e1" color:border-color="#c0392b">
        <dc:Bounds x="4742" y="902" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="4723.82421875" y="1002" width="72.3515625" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_sL" bpmnElement="sL" bioc:fill="#e3fcec" bioc:stroke="#1f8f4e" color:background-color="#e3fcec" color:border-color="#1f8f4e">
        <dc:Bounds x="2222" y="1302" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="2190.79833984375" y="1354" width="98.4033203125" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_l1" bpmnElement="l1" isExpanded="false" bioc:fill="#bfe9cf" bioc:stroke="#2e8b57" color:background-color="#bfe9cf" color:border-color="#2e8b57">
        <dc:Bounds x="2455" y="1275" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_l2" bpmnElement="l2" bioc:fill="#ffffff" bioc:stroke="#2e8b57" color:background-color="#ffffff" color:border-color="#2e8b57">
        <dc:Bounds x="2735" y="1275" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_eL" bpmnElement="eL" bioc:fill="#ffe1e1" bioc:stroke="#c0392b" color:background-color="#ffe1e1" color:border-color="#c0392b">
        <dc:Bounds x="3062" y="1302" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="3027.3154296875" y="1354" width="105.369140625" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNEdge id="Edge_F_sA_a1" bpmnElement="F_sA_a1" bioc:stroke="#2f6fde" color:border-color="#2f6fde">
        <di:waypoint x="298" y="200" />
        <di:waypoint x="495" y="200" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_a1_a2" bpmnElement="F_a1_a2" bioc:stroke="#2f6fde" color:border-color="#2f6fde">
        <di:waypoint x="625" y="200" />
        <di:waypoint x="775" y="200" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_a2_a3" bpmnElement="F_a2_a3" bioc:stroke="#2f6fde" color:border-color="#2f6fde">
        <di:waypoint x="905" y="200" />
        <di:waypoint x="1055" y="200" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_a3_a4" bpmnElement="F_a3_a4" bioc:stroke="#2f6fde" color:border-color="#2f6fde">
        <di:waypoint x="1185" y="200" />
        <di:waypoint x="3622" y="200" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_a4_a5" bpmnElement="F_a4_a5" bioc:stroke="#2f6fde" color:border-color="#2f6fde">
        <di:waypoint x="3658" y="200" />
        <di:waypoint x="3855" y="200" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_a5_eA" bpmnElement="F_a5_eA" bioc:stroke="#2f6fde" color:border-color="#2f6fde">
        <di:waypoint x="3985" y="200" />
        <di:waypoint x="4182" y="200" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_sB_b1" bpmnElement="F_sB_b1" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="858" y="600" />
        <di:waypoint x="1055" y="600" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_b1_b2" bpmnElement="F_b1_b2" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="1185" y="600" />
        <di:waypoint x="1298" y="600" />
        <di:waypoint x="1298" y="920" />
        <di:waypoint x="1335" y="920" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_b2_gB" bpmnElement="F_b2_gB" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="1465" y="920" />
        <di:waypoint x="1655" y="920" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_gB_b3" bpmnElement="F_gB_b3" bioc:stroke="#b45309" color:border-color="#b45309">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="1792.87060546875" y="871" width="18.2587890625" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="1705" y="920" />
        <di:waypoint x="1725" y="920" />
        <di:waypoint x="1725" y="911" />
        <di:waypoint x="1879" y="911" />
        <di:waypoint x="1879" y="855" />
        <di:waypoint x="1960" y="855" />
        <di:waypoint x="1960" y="875" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_gB_b5" bpmnElement="F_gB_b5" bioc:stroke="#b45309" color:border-color="#b45309">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="2904.5390625" y="863" width="25.921875" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="1680" y="895" />
        <di:waypoint x="1680" y="839" />
        <di:waypoint x="4155" y="839" />
        <di:waypoint x="4155" y="920" />
        <di:waypoint x="4175" y="920" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_b3_bc" bpmnElement="F_b3_bc" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="2025" y="920" />
        <di:waypoint x="3062" y="920" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_bc_r2" bpmnElement="F_bc_r2" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="3098" y="920" />
        <di:waypoint x="4139" y="920" />
        <di:waypoint x="4139" y="954" />
        <di:waypoint x="4399" y="954" />
        <di:waypoint x="4399" y="981" />
        <di:waypoint x="4955" y="981" />
        <di:waypoint x="4955" y="600" />
        <di:waypoint x="4975" y="600" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_r2_b5" bpmnElement="F_r2_b5" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="5040" y="555" />
        <di:waypoint x="5040" y="535" />
        <di:waypoint x="4209" y="535" />
        <di:waypoint x="4209" y="875" />
        <di:waypoint x="4200" y="875" />
        <di:waypoint x="4200" y="895" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_b5_eB" bpmnElement="F_b5_eB" bioc:stroke="#b45309" color:border-color="#b45309">
        <di:waypoint x="4545" y="920" />
        <di:waypoint x="4742" y="920" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_sL_l1" bpmnElement="F_sL_l1" bioc:stroke="#2e8b57" color:border-color="#2e8b57">
        <di:waypoint x="2258" y="1320" />
        <di:waypoint x="2455" y="1320" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_l1_l2" bpmnElement="F_l1_l2" bioc:stroke="#2e8b57" color:border-color="#2e8b57">
        <di:waypoint x="2585" y="1320" />
        <di:waypoint x="2735" y="1320" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_F_l2_eL" bpmnElement="F_l2_eL" bioc:stroke="#2e8b57" color:border-color="#2e8b57">
        <di:waypoint x="2865" y="1320" />
        <di:waypoint x="3062" y="1320" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_M_a1_sB" bpmnElement="M_a1_sB" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="676.88818359375" y="240" width="50.2236328125" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="625" y="200" />
        <di:waypoint x="645" y="200" />
        <di:waypoint x="645" y="216" />
        <di:waypoint x="759" y="216" />
        <di:waypoint x="759" y="600" />
        <di:waypoint x="822" y="600" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_M_a2_b2" bpmnElement="M_a2_b2" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="1202.64599609375" y="499" width="33.7080078125" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="905" y="200" />
        <di:waypoint x="925" y="200" />
        <di:waypoint x="925" y="216" />
        <di:waypoint x="1039" y="216" />
        <di:waypoint x="1039" y="539" />
        <di:waypoint x="1400" y="539" />
        <di:waypoint x="1400" y="875" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_M_b3_sL" bpmnElement="M_b3_sL" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="2051.4853515625" y="1171" width="97.029296875" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="1960" y="965" />
        <di:waypoint x="1960" y="1147" />
        <di:waypoint x="2240" y="1147" />
        <di:waypoint x="2240" y="1302" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_M_a3_l1" bpmnElement="M_a3_l1" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="1216.853515625" y="1560" width="46.29296875" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="1120" y="155" />
        <di:waypoint x="1120" y="0" />
        <di:waypoint x="-40" y="0" />
        <di:waypoint x="-40" y="1600" />
        <di:waypoint x="2520" y="1600" />
        <di:waypoint x="2520" y="1365" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_M_l2_bc" bpmnElement="M_l2_bc" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="2902.3408203125" y="1053" width="75.318359375" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="2800" y="1275" />
        <di:waypoint x="2800" y="1093" />
        <di:waypoint x="3080" y="1093" />
        <di:waypoint x="3080" y="938" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_M_r2_a4" bpmnElement="M_r2_a4" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="4471.30859375" y="122" width="98.3828125" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="5040" y="555" />
        <di:waypoint x="5040" y="162" />
        <di:waypoint x="4001" y="162" />
        <di:waypoint x="4001" y="139" />
        <di:waypoint x="3640" y="139" />
        <di:waypoint x="3640" y="182" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_M_a5_b5" bpmnElement="M_a5_b5" bioc:stroke="#7a7a7a" color:border-color="#7a7a7a">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="3932" y="420" width="34" height="24" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="3920" y="245" />
        <di:waypoint x="3920" y="480" />
      </bpmndi:BPMNEdge>
    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>
  <process id="Proc_labdiag" name="Лабораторная диагностика" isExecutable="false">
    <startEvent id="ls" name="Диагностика начата" />
    <sequenceFlow id="lf1" sourceRef="ls" targetRef="lt1" />
    <task id="lt1" name="Забор биоматериала" />
    <sequenceFlow id="lf2" sourceRef="lt1" targetRef="lt2" />
    <task id="lt2" name="Маркировка пробирок" />
    <sequenceFlow id="lf3" sourceRef="lt2" targetRef="lsub" />
    <callActivity id="lsub" name="Транспортировка проб" calledElement="Proc_transport" />
    <sequenceFlow id="lf4" sourceRef="lsub" targetRef="lt3" />
    <task id="lt3" name="Регистрация в ЛИС" />
    <sequenceFlow id="lf5" sourceRef="lt3" targetRef="lg" />
    <exclusiveGateway id="lg" />
    <sequenceFlow id="lf6" sourceRef="lg" targetRef="lt4" name="проба годна" />
    <sequenceFlow id="lf7" sourceRef="lg" targetRef="lt6" name="брак" />
    <task id="lt4" name="Анализ на анализаторе" />
    <sequenceFlow id="lf8" sourceRef="lt4" targetRef="lt5" />
    <task id="lt5" name="Валидация врачом КЛД" />
    <sequenceFlow id="lf9" sourceRef="lt5" targetRef="le1" />
    <endEvent id="le1" name="Результат передан">
      <messageEventDefinition id="MED_le1" />
    </endEvent>
    <task id="lt6" name="Повторный забор" />
    <sequenceFlow id="lf10" sourceRef="lt6" targetRef="le2" />
    <endEvent id="le2" name="Пациент приглашён повторно" />
  </process>
  <bpmndi:BPMNDiagram id="Diagram_Defs_lab">
    <bpmndi:BPMNPlane id="Plane_Defs_lab" bpmnElement="Proc_labdiag">
      <bpmndi:BPMNShape id="Shape_ls" bpmnElement="ls">
        <dc:Bounds x="170" y="58" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="210.79833984375" y="110" width="98.4033203125" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_lt1" bpmnElement="lt1">
        <dc:Bounds x="123" y="187" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_lt2" bpmnElement="lt2">
        <dc:Bounds x="123" y="370" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_lsub" bpmnElement="lsub">
        <dc:Bounds x="115.26708984375" y="553" width="145.4658203125" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_lt3" bpmnElement="lt3">
        <dc:Bounds x="123" y="736" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_lg" bpmnElement="lg">
        <dc:Bounds x="163" y="919" width="50" height="50" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_lt4" bpmnElement="lt4">
        <dc:Bounds x="123" y="1062" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_lt5" bpmnElement="lt5">
        <dc:Bounds x="123" y="1245" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_le1" bpmnElement="le1">
        <dc:Bounds x="170" y="1428" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="150.56298828125" y="1480" width="74.8740234375" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_lt6" bpmnElement="lt6">
        <dc:Bounds x="123" y="1557" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_le2" bpmnElement="le2">
        <dc:Bounds x="170" y="1740" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="146.70068359375" y="1792" width="82.5986328125" height="60.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNEdge id="Edge_lf1" bpmnElement="lf1">
        <di:waypoint x="188" y="94" />
        <di:waypoint x="188" y="187" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_lf2" bpmnElement="lf2">
        <di:waypoint x="188" y="277" />
        <di:waypoint x="188" y="370" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_lf3" bpmnElement="lf3">
        <di:waypoint x="188" y="460" />
        <di:waypoint x="188" y="553" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_lf4" bpmnElement="lf4">
        <di:waypoint x="188" y="643" />
        <di:waypoint x="188" y="736" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_lf5" bpmnElement="lf5">
        <di:waypoint x="188" y="826" />
        <di:waypoint x="188" y="919" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_lf6" bpmnElement="lf6">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="212" y="1007.5" width="91.6015625" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="188" y="969" />
        <di:waypoint x="188" y="1062" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_lf7" bpmnElement="lf7">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="354" y="1265" width="34.5556640625" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="213" y="944" />
        <di:waypoint x="330" y="944" />
        <di:waypoint x="330" y="1602" />
        <di:waypoint x="253" y="1602" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_lf8" bpmnElement="lf8">
        <di:waypoint x="188" y="1152" />
        <di:waypoint x="188" y="1245" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_lf9" bpmnElement="lf9">
        <di:waypoint x="188" y="1335" />
        <di:waypoint x="188" y="1428" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_lf10" bpmnElement="lf10">
        <di:waypoint x="188" y="1647" />
        <di:waypoint x="188" y="1740" />
      </bpmndi:BPMNEdge>
    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>
<process id="Proc_transport" name="Транспортировка проб" isExecutable="false">
    <startEvent id="ts" name="Пробы промаркированы" />
    <sequenceFlow id="tf1" sourceRef="ts" targetRef="tt1" />
    <task id="tt1" name="Упаковать в термоконтейнер" />
    <sequenceFlow id="tf2" sourceRef="tt1" targetRef="tt2" />
    <task id="tt2" name="Запись в журнал передачи" />
    <sequenceFlow id="tf3" sourceRef="tt2" targetRef="tt3" />
    <task id="tt3" name="Передать курьеру под подпись" />
    <sequenceFlow id="tf4" sourceRef="tt3" targetRef="tt4" />
    <task id="tt4" name="Доставить за 2 часа" />
    <sequenceFlow id="tf5" sourceRef="tt4" targetRef="tt5" />
    <task id="tt5" name="Проверка при приёмке" />
    <sequenceFlow id="tf6" sourceRef="tt5" targetRef="tg" />
    <exclusiveGateway id="tg" />
    <sequenceFlow id="tf7" sourceRef="tg" targetRef="tt6" name="в норме" />
    <sequenceFlow id="tf8" sourceRef="tg" targetRef="tt7" name="нарушения" />
    <task id="tt6" name="Принять в работу" />
    <sequenceFlow id="tf9" sourceRef="tt6" targetRef="te1" />
    <endEvent id="te1" name="Пробы в лаборатории" />
    <task id="tt7" name="Акт и повторный забор" />
    <sequenceFlow id="tf10" sourceRef="tt7" targetRef="te2" />
    <endEvent id="te2" name="Пробы забракованы" />
  </process>
  <bpmndi:BPMNDiagram id="Diagram_Defs_transport">
    <bpmndi:BPMNPlane id="Plane_Defs_transport" bpmnElement="Proc_transport">
      <bpmndi:BPMNShape id="Shape_ts" bpmnElement="ts">
        <dc:Bounds x="170" y="58" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="220.66162109375" y="110" width="126.6767578125" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_tt1" bpmnElement="tt1">
        <dc:Bounds x="118.26123046875" y="187" width="139.4775390625" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_tt2" bpmnElement="tt2">
        <dc:Bounds x="123" y="370" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_tt3" bpmnElement="tt3">
        <dc:Bounds x="123" y="553" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_tt4" bpmnElement="tt4">
        <dc:Bounds x="123" y="736" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_tt5" bpmnElement="tt5">
        <dc:Bounds x="123" y="919" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_tg" bpmnElement="tg">
        <dc:Bounds x="163" y="1102" width="50" height="50" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_tt6" bpmnElement="tt6">
        <dc:Bounds x="123" y="1245" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_te1" bpmnElement="te1">
        <dc:Bounds x="170" y="1428" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="140.00146484375" y="1480" width="95.9970703125" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_tt7" bpmnElement="tt7">
        <dc:Bounds x="123" y="1557" width="130" height="90" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Shape_te2" bpmnElement="te2">
        <dc:Bounds x="170" y="1740" width="36" height="36" />
        <bpmndi:BPMNLabel>
          <dc:Bounds x="139.9091796875" y="1792" width="96.181640625" height="42.0" />
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNEdge id="Edge_tf1" bpmnElement="tf1">
        <di:waypoint x="188" y="94" />
        <di:waypoint x="188" y="187" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_tf2" bpmnElement="tf2">
        <di:waypoint x="188" y="277" />
        <di:waypoint x="188" y="370" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_tf3" bpmnElement="tf3">
        <di:waypoint x="188" y="460" />
        <di:waypoint x="188" y="553" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_tf4" bpmnElement="tf4">
        <di:waypoint x="188" y="643" />
        <di:waypoint x="188" y="736" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_tf5" bpmnElement="tf5">
        <di:waypoint x="188" y="826" />
        <di:waypoint x="188" y="919" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_tf6" bpmnElement="tf6">
        <di:waypoint x="188" y="1009" />
        <di:waypoint x="188" y="1102" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_tf7" bpmnElement="tf7">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="212" y="1190.5" width="58.4814453125" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="188" y="1152" />
        <di:waypoint x="188" y="1245" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_tf8" bpmnElement="tf8">
        <bpmndi:BPMNLabel>
          <dc:Bounds x="366" y="1356.5" width="83.001953125" height="24.0" />
        </bpmndi:BPMNLabel>
        <di:waypoint x="213" y="1127" />
        <di:waypoint x="342" y="1127" />
        <di:waypoint x="342" y="1602" />
        <di:waypoint x="253" y="1602" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_tf9" bpmnElement="tf9">
        <di:waypoint x="188" y="1335" />
        <di:waypoint x="188" y="1428" />
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge id="Edge_tf10" bpmnElement="tf10">
        <di:waypoint x="188" y="1647" />
        <di:waypoint x="188" y="1740" />
      </bpmndi:BPMNEdge>
    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>
</definitions>
```

## Уровень 2: лабораторная диагностика

Вызываемый процесс из общей схемы; внутри — вызов транспортировки проб.
Все три процесса и их DI находятся в одном блоке, поэтому переходы доступны в просмотрщике.

Откройте этот уровень, нажав задачу вызова на предыдущей схеме. Кнопка «Назад» вернёт к ней.

## Уровень 3: транспортировка проб

Откройте этот уровень, нажав задачу вызова на предыдущей схеме. Кнопка «Назад» вернёт к ней.
