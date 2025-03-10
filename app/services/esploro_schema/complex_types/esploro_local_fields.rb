# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # Locally defined asset fields. Must be enabled in the Local Field Names configuration table.
    # https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroLocalFields
    class EsploroLocalFields < EsploroSchema::Common::AbstractComplexType
      property! :note_1, :string
      property! :note_2, :string
      property! :note_3, :string
      property! :note_4, :string
      property! :note_5, :string
      property! :note_6, :string
      property! :note_7, :string
      property! :note_8, :string
      property! :note_9, :string
      property! :note_10, :string
      property! :note_11, :string
      property! :note_12, :string
      property! :note_13, :string
      property! :note_14, :string
      property! :note_15, :string
      property! :note_16, :string
      property! :note_17, :string
      property! :note_18, :string
      property! :note_19, :string
      property! :note_20, :string
      property! :note_21, :string
      property! :note_22, :string
      property! :note_23, :string
      property! :note_24, :string
      property! :note_25, :string
      property! :note_26, :string
      property! :note_27, :string
      property! :note_28, :string
      property! :note_29, :string
      property! :note_30, :string
      property! :note_31, :string
      property! :note_32, :string
      property! :note_33, :string
      property! :note_34, :string
      property! :note_35, :string
      property! :note_36, :string
      property! :note_37, :string
      property! :note_38, :string
      property! :note_39, :string
      property! :note_40, :string
      property! :note_41, :string
      property! :note_42, :string
      property! :note_43, :string
      property! :note_44, :string
      property! :note_45, :string
      property! :note_46, :string
      property! :note_47, :string
      property! :note_48, :string
      property! :note_49, :string
      property! :note_50, :string
      property! :field_1, :string
      property! :field_2, :string
      property! :field_3, :string
      property! :field_4, :string
      property! :field_5, :string
      property! :field_6, :string
      property! :field_7, :string
      property! :field_8, :string
      property! :field_9, :string
      property! :field_10, :string
      property! :field_11, :string
      property! :field_12, :string
      property! :field_13, :string
      property! :field_14, :string
      property! :field_15, :string

      xml do
        root "esploroLocalFields", mixed: true

        map_element "local.note1", to: :note_1
        map_element "local.note2", to: :note_2
        map_element "local.note3", to: :note_3
        map_element "local.note4", to: :note_4
        map_element "local.note5", to: :note_5
        map_element "local.note6", to: :note_6
        map_element "local.note7", to: :note_7
        map_element "local.note8", to: :note_8
        map_element "local.note9", to: :note_9
        map_element "local.note10", to: :note_10
        map_element "local.note11", to: :note_11
        map_element "local.note12", to: :note_12
        map_element "local.note13", to: :note_13
        map_element "local.note14", to: :note_14
        map_element "local.note15", to: :note_15
        map_element "local.note16", to: :note_16
        map_element "local.note17", to: :note_17
        map_element "local.note18", to: :note_18
        map_element "local.note19", to: :note_19
        map_element "local.note20", to: :note_20
        map_element "local.note21", to: :note_21
        map_element "local.note22", to: :note_22
        map_element "local.note23", to: :note_23
        map_element "local.note24", to: :note_24
        map_element "local.note25", to: :note_25
        map_element "local.note26", to: :note_26
        map_element "local.note27", to: :note_27
        map_element "local.note28", to: :note_28
        map_element "local.note29", to: :note_29
        map_element "local.note30", to: :note_30
        map_element "local.note31", to: :note_31
        map_element "local.note32", to: :note_32
        map_element "local.note33", to: :note_33
        map_element "local.note34", to: :note_34
        map_element "local.note35", to: :note_35
        map_element "local.note36", to: :note_36
        map_element "local.note37", to: :note_37
        map_element "local.note38", to: :note_38
        map_element "local.note39", to: :note_39
        map_element "local.note40", to: :note_40
        map_element "local.note41", to: :note_41
        map_element "local.note42", to: :note_42
        map_element "local.note43", to: :note_43
        map_element "local.note44", to: :note_44
        map_element "local.note45", to: :note_45
        map_element "local.note46", to: :note_46
        map_element "local.note47", to: :note_47
        map_element "local.note48", to: :note_48
        map_element "local.note49", to: :note_49
        map_element "local.note50", to: :note_50
        map_element "localField1", to: :field_1
        map_element "localField2", to: :field_2
        map_element "localField3", to: :field_3
        map_element "localField4", to: :field_4
        map_element "localField5", to: :field_5
        map_element "localField6", to: :field_6
        map_element "localField7", to: :field_7
        map_element "localField8", to: :field_8
        map_element "localField9", to: :field_9
        map_element "localField10", to: :field_10
        map_element "localField11", to: :field_11
        map_element "localField12", to: :field_12
        map_element "localField13", to: :field_13
        map_element "localField14", to: :field_14
        map_element "localField15", to: :field_15
      end
    end
  end
end
