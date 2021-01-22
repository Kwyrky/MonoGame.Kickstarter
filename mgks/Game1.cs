using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System;

namespace MONOGAMEKICKSTARTERNAMESPACE.NetStandardLibrary
{
    public class Game1 : Game
    {
        private GraphicsDeviceManager graphics;
        private SpriteBatch spriteBatch;

        // MonoGame.Kickstarter sample code BEGIN
        public enum Platform { Android, Windows, Linux, MacOS, Other }
        public enum GraphicsBackend { OpenGL, DirectX, Other }
        //
        private Platform platform = Platform.Other;
        private Platform platformByConditionalCompilationSymbols = Platform.Other;
        private GraphicsBackend graphicsBackend = GraphicsBackend.OpenGL;
        //
        private Effect effect;
        private Texture2D texture;
        private Matrix baseWorld;
        private Matrix world;
        private Matrix view;
        private Matrix projection;
        private IndexBuffer indexBuffer;
        private VertexBuffer vertexBuffer;
        private VertexPositionColorTexture[] vertices;
        private int[] indices;
        // MonoGame.Kickstarter sample code END

        public Game1()
        {
            graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
            IsMouseVisible = true;
        }

        protected override void Initialize()
        {
            // MonoGame.Kickstarter sample code BEGIN
            GetCurrentPlatform();
            GetCurrentPlatformByConditionalCompilationSymbols();
            // MonoGame.Kickstarter sample code END

            base.Initialize();
        }

        protected override void LoadContent()
        {
            spriteBatch = new SpriteBatch(GraphicsDevice);

            // MonoGame.Kickstarter sample code BEGIN
            LoadEffect();
            LoadVerticesIndicesBufferMatrices();
            // MonoGame.Kickstarter sample code END
        }

        // MonoGame.Kickstarter sample code BEGIN
        private void LoadVerticesIndicesBufferMatrices()
        {
            vertexBuffer = new VertexBuffer(GraphicsDevice, VertexPositionColorTexture.VertexDeclaration, 4, BufferUsage.WriteOnly);
            indexBuffer = new IndexBuffer(GraphicsDevice, IndexElementSize.ThirtyTwoBits, 6, BufferUsage.WriteOnly);

            vertices = new VertexPositionColorTexture[4];
            indices = new int[6];

            float size = 0.5f;

            vertices[0] = new VertexPositionColorTexture(new Vector3(-size, +size, 0), Color.White, new Vector2(0, 0));
            vertices[1] = new VertexPositionColorTexture(new Vector3(+size, +size, 0), Color.White, new Vector2(1, 0));
            vertices[2] = new VertexPositionColorTexture(new Vector3(+size, -size, 0), Color.White, new Vector2(1, 1));
            vertices[3] = new VertexPositionColorTexture(new Vector3(-size, -size, 0), Color.White, new Vector2(0, 1));

            indices[0] = 0;
            indices[1] = 3;
            indices[2] = 2;
            indices[3] = 2;
            indices[4] = 1;
            indices[5] = 0;

            vertexBuffer.SetData(vertices);
            indexBuffer.SetData(indices);

            baseWorld = Matrix.CreateScale(5.0f) * Matrix.CreateTranslation(2.0f * Vector3.Forward);
            world = Matrix.Identity;
            view = Matrix.CreateLookAt(Vector3.Zero, Vector3.Forward, Vector3.Up);
            projection = Matrix.CreatePerspective(10.0f * GraphicsDevice.Viewport.AspectRatio, 10.0f, 1.0f, 1000.0f);
        }
        // MonoGame.Kickstarter sample code END

        // MonoGame.Kickstarter sample code BEGIN
        private void LoadEffect()
        {
#if ANDROID // After the Android project has been added to the solution add a "ANDROID" to "Conditional compilation symbols" (Project Properties|Build|Conditional compilation symbols)
            effect = Content.Load<Effect>("androideffect");
            texture = Content.Load<Texture2D>("androidtexture");
#elif OPENGL
            effect = Content.Load<Effect>("effect");
            texture = Content.Load<Texture2D>("texture");
#else
            effect = Content.Load<Effect>("effect");
            texture = Content.Load<Texture2D>("texture");
#endif
        }
        // MonoGame.Kickstarter sample code END

        protected override void Update(GameTime gameTime)
        {
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
                Exit();

            // MonoGame.Kickstarter sample code BEGIN
            UpdateAnimation(gameTime);
            // MonoGame.Kickstarter sample code END

            base.Update(gameTime);
        }

        // MonoGame.Kickstarter sample code BEGIN
        private void UpdateAnimation(GameTime gameTime)
        {
            float radians = (float)(Math.Sin(gameTime.TotalGameTime.TotalSeconds));
            world = Matrix.CreateRotationZ(radians);
        }
        // MonoGame.Kickstarter sample code END

        protected override void Draw(GameTime gameTime)
        {
            GraphicsDevice.Clear(Color.CornflowerBlue);

            // MonoGame.Kickstarter sample code BEGIN
            // ClearBackgroundBasedOnCurrentPlatform(CurrentPlatform);
            // MonoGame.Kickstarter sample code END

            // MonoGame.Kickstarter sample code BEGIN
            ClearBackgroundBasedOnConditionalCompilationSymbol();
            DrawQuad();
            // MonoGame.Kickstarter sample code END

            base.Draw(gameTime);
        }

        private void DrawQuad()
        {
            GraphicsDevice.RasterizerState = RasterizerState.CullNone;

            GraphicsDevice.Indices = indexBuffer;
            GraphicsDevice.SetVertexBuffer(vertexBuffer);

            effect.Parameters["World"].SetValue(baseWorld * world);
            effect.Parameters["View"].SetValue(view);
            effect.Parameters["Projection"].SetValue(projection);
            effect.Parameters["Texture"].SetValue(texture);

            foreach (EffectPass pass in effect.CurrentTechnique.Passes)
            {
                pass.Apply();
                GraphicsDevice.DrawIndexedPrimitives(PrimitiveType.TriangleList, 0, 0, 2);
            }
        }

        // MonoGame.Kickstarter sample code BEGIN
        private void ClearBackgroundBasedOnConditionalCompilationSymbol()
        {
#if ANDROID // After the Android project has been added to the solution add a "ANDROID" to "Conditional compilation symbols" (Project Properties|Build|Conditional compilation symbols)
            GraphicsDevice.Clear(Color.MonoGameOrange);
#elif OPENGL
            GraphicsDevice.Clear(Color.Lime);
#else
            GraphicsDevice.Clear(Color.CornflowerBlue);
#endif
        }
        // MonoGame.Kickstarter sample code END

        // MonoGame.Kickstarter sample code BEGIN
        private void ClearBackgroundBasedOnCurrentPlatform(Platform Platform)
        {
            switch (Platform)
            {
                case Platform.Windows:
                    GraphicsDevice.Clear(Color.Red);
                    break;
                case Platform.Linux:
                    GraphicsDevice.Clear(Color.Green);
                    break;
                case Platform.MacOS:
                    GraphicsDevice.Clear(Color.Blue);
                    break;
                case Platform.Other:
                    GraphicsDevice.Clear(Color.Gray);
                    break;
                default:
                    break;
            }
        }
        // MonoGame.Kickstarter sample code END

        // MonoGame.Kickstarter sample code BEGIN
        private void GetCurrentPlatform()
        {
            if (Environment.OSVersion.Platform == PlatformID.Win32NT)
            {
                platform = Platform.Windows;
            }
            else if (Environment.OSVersion.Platform == PlatformID.Unix)
            {
                platform = Platform.Linux;
            }
            else if (Environment.OSVersion.Platform == PlatformID.MacOSX)
            {
                platform = Platform.MacOS;
            }
            else
            {
                platform = Platform.Other;
            }

            graphicsBackend = GraphicsBackend.OpenGL;
        }
        // MonoGame.Kickstarter sample code END

        // MonoGame.Kickstarter sample code BEGIN
        private void GetCurrentPlatformByConditionalCompilationSymbols()
        {
#if ANDROID
            platformByConditionalCompilationSymbols = Platform.Android;
#else
            platformByConditionalCompilationSymbols = Platform.Other;
#endif
        }
        // MonoGame.Kickstarter sample code END
    }
}
