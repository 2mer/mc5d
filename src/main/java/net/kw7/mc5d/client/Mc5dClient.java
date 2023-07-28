package net.kw7.mc5d.client;

import ladysnake.satin.api.event.ShaderEffectRenderCallback;
import ladysnake.satin.api.managed.ManagedShaderEffect;
import ladysnake.satin.api.managed.ShaderEffectManager;
import net.fabricmc.api.ClientModInitializer;
import net.kw7.mc5d.Mc5d;
import net.minecraft.util.Identifier;

import java.util.concurrent.atomic.AtomicReference;

public class Mc5dClient implements ClientModInitializer {
    private static final ManagedShaderEffect GREYSCALE_SHADER = ShaderEffectManager.getInstance()
            .manage(new Identifier(Mc5d.MOD_ID, "shaders/post/test.json"));
    private static final boolean enabled = true;

    /**
     * Runs the mod initializer on the client environment.
     */
    @Override
    public void onInitializeClient() {

        AtomicReference<Float> time = new AtomicReference<>((float) 0);

        ShaderEffectRenderCallback.EVENT.register(tickDelta -> {
            time.updateAndGet(v -> (v + tickDelta / 20));

            if (enabled) {
                GREYSCALE_SHADER.setUniformValue("pTime", time.get());
                GREYSCALE_SHADER.render(tickDelta);
            }
        });

    }
}
