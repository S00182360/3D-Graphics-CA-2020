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
    class CustomEffectModel : SimpleModel
    {
        public Effect CustomEffect;
        public Material Material;

        public CustomEffectModel(string assetName, Vector3 position) : base("", assetName, position)
        {

        }

        private void GenerateMeshTag()
        {
            foreach (ModelMesh mesh in Model.Meshes)
            {
                foreach (ModelMeshPart part in mesh.MeshParts)
                {

                    if (part.Effect is BasicEffect)
                    {
                        MeshTag tag = new MeshTag();
                        tag.Color = (part.Effect as BasicEffect).DiffuseColor;
                        tag.Texture = (part.Effect as BasicEffect).Texture;
                        tag.SpecularPower = (part.Effect as BasicEffect).SpecularPower;

                        part.Tag = tag;
                    }
                }
            }
        }

        public virtual void CacheEffect()
        {
            foreach (ModelMesh mesh in Model.Meshes)
            {
                foreach (ModelMeshPart part in mesh.MeshParts)
                {
                    if (part.Tag != null)
                        if ((part.Tag as MeshTag).CacheEffect != null)
                            (part.Tag as MeshTag).CacheEffect = part.Effect;
                }
            }
        }

        public virtual void RestoreEffect()
        {
            foreach (ModelMesh mesh in Model.Meshes)
            {
                foreach (ModelMeshPart part in mesh.MeshParts)
                {
                    if ((part.Tag as MeshTag).CacheEffect != null)
                        part.Effect = (part.Tag as MeshTag).CacheEffect;
                }
            }
        }


        public virtual void SetEffectParameter(Effect effect, string paramName, object value)
        {
            //if param is not on the effect, return to caller
            if (effect.Parameters[paramName] == null)
                return;

            if (value is Vector3)
                effect.Parameters[paramName].SetValue((Vector3)value);
            else if (value is Matrix)
                effect.Parameters[paramName].SetValue((Matrix)value);
            else if (value is bool)
                effect.Parameters[paramName].SetValue((bool)value);
            else if (value is Texture2D)
                effect.Parameters[paramName].SetValue((Texture2D)value);
            else if (value is float)
                effect.Parameters[paramName].SetValue((float)value);
            else if (value is int)
                effect.Parameters[paramName].SetValue((int)value);

        }

        public virtual void SetModelEffect(Effect effect, bool copyEffect)
        {
            foreach (ModelMesh mesh in Model.Meshes)
            {
                foreach (ModelMeshPart part in mesh.MeshParts)
                {
                    Effect toBeSet = effect;

                    if (copyEffect)
                        toBeSet = effect.Clone();

                    var tag = (part.Tag as MeshTag);

                    if (tag.Texture != null)
                    {
                        SetEffectParameter(toBeSet, "Texture", tag.Texture);
                        SetEffectParameter(toBeSet, "TextureEnabled", true);
                    }
                    else
                        SetEffectParameter(toBeSet, "TextureEnabled", false);

                    SetEffectParameter(toBeSet, "DiffuseColo", tag.Color);
                    SetEffectParameter(toBeSet, "SpecularPower", tag.SpecularPower);

                    part.Effect = toBeSet;
                }
            }
        }

        public override void LoadContent()
        {
            base.LoadContent();

            //replace effect that was applied to the model
            //default is BasicEffect
            //replace with any custom effect
            if (Model != null)
            {
                GenerateMeshTag();

                if (CustomEffect != null)
                    foreach (ModelMesh mesh in Model.Meshes)
                        foreach (ModelMeshPart part in mesh.MeshParts)
                            part.Effect = CustomEffect;
            }
        }

        public override void Draw(Camera camera)
        {
            if (CustomEffect != null)
            {
                SetModelEffect(CustomEffect, false);

                foreach (ModelMesh mesh in Model.Meshes)
                {
                    foreach (ModelMeshPart part in mesh.MeshParts)
                    {
                        CustomEffect.Parameters["World"].SetValue(BoneTransforms[mesh.ParentBone.Index] * World);
                        CustomEffect.Parameters["View"].SetValue(camera.View);
                        CustomEffect.Parameters["Projection"].SetValue(camera.Projection);

                        if (Material != null)
                            Material.SetEffectParam(part.Effect);
                    }

                    mesh.Draw();
                }
            }
            else
            {
                base.Draw(camera);
            }
        }

    }
}
