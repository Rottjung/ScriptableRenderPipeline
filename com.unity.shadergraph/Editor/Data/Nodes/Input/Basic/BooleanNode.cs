using System.Collections.Generic;
using UnityEditor.ShaderGraph.Drawing.Controls;
using UnityEngine;
using UnityEditor.Graphing;

namespace UnityEditor.ShaderGraph
{
    [Title("Input", "Basic", "Boolean")]
    class BooleanNode : AbstractMaterialNode, IGeneratesBodyCode, IPropertyFromNode
    {
        [SerializeField]
        private bool m_Value;

        public const int OutputSlotId = 0;
        private const string kOutputSlotName = "Out";

        public BooleanNode()
        {
            name = "Boolean";
            UpdateNodeAfterDeserialization();
        }


        public sealed override void UpdateNodeAfterDeserialization()
        {
            AddSlot(new BooleanMaterialSlot(OutputSlotId, kOutputSlotName, kOutputSlotName, SlotType.Output, false));
            RemoveSlotsNameNotMatching(new[] { OutputSlotId });
        }

        [ToggleControl("")]
        public ToggleData value
        {
            get { return new ToggleData(m_Value); }
            set
            {
                if (m_Value == value.isOn)
                    return;
                m_Value = value.isOn;
                Dirty(ModificationScope.Node);
            }
        }

        public override void CollectShaderProperties(PropertyCollector properties, GenerationMode generationMode)
        {
            if (!generationMode.IsPreview())
                return;

            properties.AddShaderProperty(new BooleanShaderProperty()
            {
                overrideReferenceName = GetVariableNameForNode(),
                generatePropertyBlock = false,
                value = m_Value
            });
        }

        public void GenerateNodeCode(ShaderSnippetRegistry registry, GraphContext graphContext, GenerationMode generationMode)
        {
            if (generationMode.IsPreview())
                return;

            using(registry.ProvideSnippet(GetVariableNameForNode(), guid, out var s))
            {
                s.AppendLine("$precision {0} = {1};", GetVariableNameForNode(), (m_Value ? 1 : 0));
            }
        }

        public override string GetVariableNameForSlot(int slotId)
        {
            return GetVariableNameForNode();
        }

        public override void CollectPreviewMaterialProperties(List<PreviewProperty> properties)
        {
            properties.Add(new PreviewProperty(PropertyType.Boolean)
            {
                name = GetVariableNameForNode(),
                booleanValue = m_Value
            });
        }

        public AbstractShaderProperty AsShaderProperty()
        {
            return new BooleanShaderProperty { value = m_Value };
        }

        public int outputSlotId { get { return OutputSlotId; } }
    }
}
