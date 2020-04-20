using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DefaultMonogame
{
    class MeshTag
    {
        public Vector3 Color;
        public Texture2D Texture;
        public float SpecularPower;
        public Effect CacheEffect;
        
        public MeshTag() { }

        public MeshTag(Vector3 color, Texture2D texture, float specularPower)
        {
            Color = color;
            Texture = texture;
            SpecularPower = specularPower;
        }

    }
}
