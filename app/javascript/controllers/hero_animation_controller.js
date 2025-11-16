import { Controller } from "@hotwired/stimulus"
import * as THREE from "three"

export default class extends Controller {
  static values = {
    particleCount: { type: Number, default: 1000 },
    colorPrimary: { type: String, default: "#1a1a1f" },
    colorAccent: { type: String, default: "#d4a962" }
  }

  connect() {
    this.initScene()
    this.createParticles()
    this.animate()
    this.setupMouseTracking()
    this.setupResize()
  }

  disconnect() {
    window.removeEventListener('mousemove', this.onMouseMove)
    window.removeEventListener('resize', this.onResize)
    if (this.animationId) {
      cancelAnimationFrame(this.animationId)
    }
    if (this.renderer) {
      this.renderer.dispose()
    }
  }

  initScene() {
    // Scene setup
    this.scene = new THREE.Scene()
    this.scene.fog = new THREE.Fog(0xf7f7f8, 1, 1000)

    // Camera setup
    this.camera = new THREE.PerspectiveCamera(
      75,
      this.element.clientWidth / this.element.clientHeight,
      1,
      1000
    )
    this.camera.position.z = 400

    // Renderer setup
    this.renderer = new THREE.WebGLRenderer({
      canvas: this.element,
      alpha: true,
      antialias: true
    })
    this.renderer.setSize(this.element.clientWidth, this.element.clientHeight)
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

    // Mouse position
    this.mouse = { x: 0, y: 0 }
    this.targetMouse = { x: 0, y: 0 }
  }

  createParticles() {
    const geometry = new THREE.BufferGeometry()
    const positions = []
    const colors = []
    const sizes = []

    const color1 = new THREE.Color(this.colorPrimaryValue)
    const color2 = new THREE.Color(this.colorAccentValue)

    for (let i = 0; i < this.particleCountValue; i++) {
      // Position particles in a sphere
      const theta = THREE.MathUtils.randFloatSpread(360)
      const phi = THREE.MathUtils.randFloatSpread(360)
      const radius = 300

      positions.push(
        radius * Math.sin(theta) * Math.cos(phi),
        radius * Math.sin(theta) * Math.sin(phi),
        radius * Math.cos(theta)
      )

      // Mix colors
      const mixedColor = color1.clone()
      mixedColor.lerp(color2, Math.random())
      colors.push(mixedColor.r, mixedColor.g, mixedColor.b)

      // Random sizes
      sizes.push(Math.random() * 2 + 0.5)
    }

    geometry.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3))
    geometry.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3))
    geometry.setAttribute('size', new THREE.Float32BufferAttribute(sizes, 1))

    // Shader material for better performance and aesthetics
    const material = new THREE.PointsMaterial({
      size: 2,
      vertexColors: true,
      transparent: true,
      opacity: 0.8,
      blending: THREE.AdditiveBlending,
      depthWrite: false,
      sizeAttenuation: true
    })

    this.particles = new THREE.Points(geometry, material)
    this.scene.add(this.particles)

    // Add subtle ambient light
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.5)
    this.scene.add(ambientLight)
  }

  setupMouseTracking() {
    this.onMouseMove = (event) => {
      this.targetMouse.x = (event.clientX / window.innerWidth) * 2 - 1
      this.targetMouse.y = -(event.clientY / window.innerHeight) * 2 + 1
    }
    window.addEventListener('mousemove', this.onMouseMove)
  }

  setupResize() {
    this.onResize = () => {
      this.camera.aspect = this.element.clientWidth / this.element.clientHeight
      this.camera.updateProjectionMatrix()
      this.renderer.setSize(this.element.clientWidth, this.element.clientHeight)
    }
    window.addEventListener('resize', this.onResize)
  }

  animate() {
    this.animationId = requestAnimationFrame(() => this.animate())

    // Smooth mouse following
    this.mouse.x += (this.targetMouse.x - this.mouse.x) * 0.05
    this.mouse.y += (this.targetMouse.y - this.mouse.y) * 0.05

    // Rotate particles based on time and mouse
    const time = Date.now() * 0.0001
    this.particles.rotation.x = time * 0.3 + this.mouse.y * 0.2
    this.particles.rotation.y = time * 0.5 + this.mouse.x * 0.2

    // Subtle breathing effect
    const breathScale = 1 + Math.sin(time * 2) * 0.05
    this.particles.scale.set(breathScale, breathScale, breathScale)

    this.renderer.render(this.scene, this.camera)
  }
}
