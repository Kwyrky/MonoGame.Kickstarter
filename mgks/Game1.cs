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

        public Game1()
        {
            graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
            IsMouseVisible = true;
        }

        protected override void Initialize()
        {
            GetCurrentPlatform();
            GetCurrentPlatformByConditionalCompilationSymbols();

            base.Initialize();
        }

        protected override void LoadContent()
        {
            spriteBatch = new SpriteBatch(GraphicsDevice);

            LoadEffect();
            LoadVerticesIndicesBufferMatrices();
        }

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

        private void LoadEffect()
        {
#if ANDROID
            effect = Content.Load<Effect>("androideffect");
            texture = Content.Load<Texture2D>("androidtexture");
#elif DESKTOPGL
            effect = Content.Load<Effect>("effect");
            texture = Content.Load<Texture2D>("texture");
#elif WINDOWSDX
            effect = Content.Load<Effect>("effect");
            texture = Content.Load<Texture2D>("texture");
#else
            effect = Content.Load<Effect>("effect");
            texture = Content.Load<Texture2D>("texture");
#endif
        }

        // necessary until fix for is applied to nugets
        // https://github.com/MonoGame/MonoGame/pull/7459
        // but may also be used to get informed about the game exiting anyway
        // although there should be already events for that scenario.
        public event EventHandler ExitedEventHandler;
        protected virtual void OnExitedEventHandler(EventArgs e)
        {
            ExitedEventHandler?.Invoke(this, e);
        }

        protected override void Update(GameTime gameTime)
        {
            GamePadState gamePadState = GamePad.GetState(PlayerIndex.One);
            bool isBackButtonPressed = gamePadState.Buttons.Back == ButtonState.Pressed;
            if (isBackButtonPressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
            {
                Exit();
                // necessary until fix for is applied to nugets
                // https://github.com/MonoGame/MonoGame/pull/7459
                // but may also be used to get informed about the game exiting anyway
                // although there should be already events for that scenario.
                OnExitedEventHandler(EventArgs.Empty);
                // TODO: Add this to Activity1.cs before "_game.Run();":
                // _game.ExitedEventHandler += (object s, EventArgs e) => { Process.KillProcess(Process.MyPid()); };
            }

            UpdateAnimation(gameTime);

            base.Update(gameTime);
        }

        private void UpdateAnimation(GameTime gameTime)
        {
            float radians = (float)(Math.Sin(gameTime.TotalGameTime.TotalSeconds));
            world = Matrix.CreateRotationZ(radians);
        }

        protected override void Draw(GameTime gameTime)
        {
            //GraphicsDevice.Clear(Color.CornflowerBlue);

            // ClearBackgroundBasedOnCurrentPlatform(platform);
            ClearBackgroundBasedOnConditionalCompilationSymbol();
            DrawQuad();

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

        private void ClearBackgroundBasedOnConditionalCompilationSymbol()
        {
#if ANDROID // After the Android project has been added to the solution add "ANDROID" to "Conditional compilation symbols" (Project Properties|Build|Conditional compilation symbols)
            GraphicsDevice.Clear(Color.MonoGameOrange);
#elif DESKTOPGL
            GraphicsDevice.Clear(Color.Lime);
#else
            GraphicsDevice.Clear(Color.CornflowerBlue);
#endif
        }

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

        private void GetCurrentPlatformByConditionalCompilationSymbols()
        {
#if ANDROID
            platformByConditionalCompilationSymbols = Platform.Android;
#else
            platformByConditionalCompilationSymbols = Platform.Other;
#endif
        }
    }
}
