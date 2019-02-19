namespace UnityEngine.Rendering.LWRP
{
    /// <summary>
    /// Draw the skybox into the given color buffer using the given depth buffer for depth testing.
    ///
    /// This pass renders the standard Unity skybox.
    /// </summary>
    internal class DrawSkyboxPass : ScriptableRenderPass
    {
        RenderTargetHandle colorAttachmentHandle { get; set; }
        RenderTargetHandle depthAttachmentHandle { get; set; }
        RenderTextureDescriptor descriptor { get; set; }

        bool m_CombineWithRenderOpaquesPass = false;

        public DrawSkyboxPass(RenderPassEvent evt)
        {
            renderPassEvent = evt;
            profilerTag = "Draw Skybox (Set RT's)";
        }

        /// <summary>
        /// Configure the color and depth passes to use when rendering the skybox
        /// </summary>
        /// <param name="colorHandle">Color buffer to use</param>
        /// <param name="depthHandle">Depth buffer to use</param>
        public void Setup(RenderTextureDescriptor baseDescriptor, RenderTargetHandle colorHandle, RenderTargetHandle depthHandle, bool combineWithRenderOpaquesPass)
        {
            descriptor = baseDescriptor;
            this.colorAttachmentHandle = colorHandle;
            this.depthAttachmentHandle = depthHandle;
            this.m_CombineWithRenderOpaquesPass = combineWithRenderOpaquesPass;
        }

        public override bool ShouldExecute(ref RenderingData renderingData)
        {
            return renderingData.cameraData.camera.clearFlags == CameraClearFlags.Skybox && RenderSettings.skybox != null;
        }

        /// <inheritdoc/>
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            // For now, we can't combine Skybox and Opaques into a single render pass if there's a custom render pass injected
            // between them.
            if (!m_CombineWithRenderOpaquesPass)
            {
                CommandBuffer cmd = CommandBufferPool.Get(profilerTag);

                RenderBufferLoadAction loadOp = RenderBufferLoadAction.Load;
                RenderBufferStoreAction storeOp = RenderBufferStoreAction.Store;

                SetRenderTarget(cmd, colorAttachmentHandle.Identifier(), loadOp, storeOp,
                    depthAttachmentHandle.Identifier(), loadOp, storeOp, ClearFlag.None, Color.black, descriptor.dimension);
                context.ExecuteCommandBuffer(cmd);
                CommandBufferPool.Release(cmd);
            }

            context.DrawSkybox(renderingData.cameraData.camera);
        }
    }
}
