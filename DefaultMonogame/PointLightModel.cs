using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Sample;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DefaultMonogame
{
    public class PointLightModel : CustomEffectModel
    {
        public PointLightModel(string assetName, Vector3 position) : base(assetName, position)
        {
        }


        public override void LoadContent()
        {
            CustomEffect = GameUtilities.Content.Load<Effect>("Effects\\PointLight");

            CustomEffect.Parameters["Texture"].SetValue(GameUtilities.Content.Load<Texture2D>("Textures/white"));
            CustomEffect.Parameters["TextureEnabled"].SetValue(true);

            base.LoadContent();
        }

        public override void Update()
        {
            base.Update();
        }


        //Point Light Material class
        public class PointLightMaterial : Material
        {
            public Vector3 AmbientLightColor { get; set; }
            public Vector3 LightPosition { get; set; }
            public Color LightColor { get; set; }

            public float Attenuation { get; set; }

            public Color AmbientColor { get; set; }
            public float LightFallOff { get; set; }

            public Texture2D Texture { get; set; }
            public Color DiffuseColor { get; set; }

            public PointLightMaterial(Color ambientColor, Color lightColor, Vector3 lightPosition, float attenuation, float lightFallOff)
            {
                AmbientColor = ambientColor;
                LightColor = lightColor;
                LightPosition = lightPosition;
                Attenuation = attenuation;
                LightFallOff = lightFallOff;
            }

            public override void SetEffectParam(Effect effect)
            {
                if (effect.Parameters["AmbientLightColor"] != null)
                    effect.Parameters["AmbientLightColor"].SetValue(AmbientColor.ToVector3());

                if (effect.Parameters["DiffuseColor"] != null)
                    effect.Parameters["DiffuseColor"].SetValue(DiffuseColor.ToVector3());

                if (effect.Parameters["LightPosition"] != null)
                    effect.Parameters["LightPosition"].SetValue(LightPosition);

                if (effect.Parameters["LightColor"] != null)
                    effect.Parameters["LightColor"].SetValue(LightColor.ToVector3());

                if (effect.Parameters["LightAttenuation"] != null)
                    effect.Parameters["LightAttenuation"].SetValue(Attenuation);

                if (effect.Parameters["LightFalloff"] != null)
                    effect.Parameters["LightFalloff"].SetValue(LightFallOff);

                if (effect.Parameters["Texture"] != null)
                    effect.Parameters["Texture"].SetValue(LightFallOff);

                base.SetEffectParam(effect);
            }

        }
    }
}
