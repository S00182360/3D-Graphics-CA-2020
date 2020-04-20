using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DefaultMonogame
{
    public abstract class Material
    {
        public virtual void Update() { }

        public virtual void SetEffectParam(Effect effect) { }
    }
}
