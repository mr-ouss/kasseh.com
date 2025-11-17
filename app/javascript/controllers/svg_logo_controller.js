import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = { url: String }
  
  async connect() {
    await this.loadAndAnimateSVG()
  }
  
  async loadAndAnimateSVG() {
    try {
      const response = await fetch(this.urlValue)
      const svgText = await response.text()
      
      // Insert the SVG into the container
      this.containerTarget.innerHTML = svgText
      
      // Get the SVG element and style it
      const svg = this.containerTarget.querySelector('svg')
      if (!svg) return
      
      svg.style.width = '100%'
      svg.style.height = '100%'
      svg.style.overflow = 'visible'
      
      // Initialize path animation
      this.initializePathAnimation(svg)
    } catch (error) {
      console.error('Error loading SVG:', error)
    }
  }
  
  initializePathAnimation(svg) {
    const paths = svg.querySelectorAll('path')
    
    this.animationComplete = false
    
    // Add hover effect to container for logo and background glow
    this.containerTarget.addEventListener('mouseenter', () => this.addHoverEffect())
    this.containerTarget.addEventListener('mouseleave', () => this.removeHoverEffect())
    
    // Get total path lengths for animation
    const pathData = Array.from(paths).map(path => {
      const length = path.getTotalLength()
      
      // Set up the initial state - paths are invisible
      path.style.strokeDasharray = length
      path.style.strokeDashoffset = length
      path.style.stroke = '#d4a962' // Gold color for tracing
      path.style.strokeWidth = '2'
      path.style.fill = 'none'
      path.style.filter = 'drop-shadow(0 0 8px rgba(212, 169, 98, 0.6))'
      path.style.transition = 'fill 0.15s ease, filter 0.15s ease'
      
      return { path, length }
    })
    
    // Animate each path sequentially with overlap
    this.animatePathsSequentially(pathData)
  }
  
  animatePathsSequentially(pathData) {
    let delay = 0
    const drawDuration = 800 // 0.8 seconds per path
    const overlapDelay = 600 // Start next path 600ms before current finishes
    
    pathData.forEach(({ path, length }, index) => {
      setTimeout(() => {
        this.animatePath(path, length, drawDuration)
      }, delay)
      
      delay += drawDuration - overlapDelay
    })
    
    // After all paths are drawn, fill them in
    setTimeout(() => {
      this.fillPaths(pathData.map(d => d.path))
    }, delay + drawDuration)
  }
  
  animatePath(path, length, duration) {
    const startTime = performance.now()
    
    const animate = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / duration, 1)
      
      // Easing function for smooth animation
      const eased = this.easeOutExpo(progress)
      
      // Update stroke dash offset
      const offset = length * (1 - eased)
      path.style.strokeDashoffset = offset
      
      // Subtle pulsing glow
      const glowIntensity = 0.5 + (Math.sin(progress * Math.PI * 2) * 0.2)
      path.style.filter = `drop-shadow(0 0 ${6 + glowIntensity * 8}px rgba(212, 169, 98, ${glowIntensity}))`
      
      if (progress < 1) {
        requestAnimationFrame(animate)
      }
    }
    
    requestAnimationFrame(animate)
  }
  
  fillPaths(paths) {
    const fillDuration = 600
    const startTime = performance.now()
    
    const animate = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / fillDuration, 1)
      const eased = this.easeInOutCubic(progress)
      
      paths.forEach(path => {
        // Transition from gold stroke to white fill
        const fillOpacity = eased
        const strokeOpacity = 1 - eased
        
        path.style.fill = `rgba(255, 255, 255, ${fillOpacity})` // White fill
        path.style.strokeOpacity = strokeOpacity
        
        // Fade out the glow completely as we finish
        const glowIntensity = 0.6 * (1 - eased)
        path.style.filter = `drop-shadow(0 0 ${8 + glowIntensity * 8}px rgba(212, 169, 98, ${glowIntensity}))`
      })
      
      if (progress < 1) {
        requestAnimationFrame(animate)
      } else {
        // Final state - clean white logo with no glow, ready for spotlight
        paths.forEach(path => {
          path.style.fill = 'white'
          path.style.stroke = 'none'
          path.style.filter = 'none'
          path.style.pointerEvents = 'all' // Ensure paths receive mouse events
        })
        
        // Mark animation as complete
        this.animationComplete = true
      }
    }
    
    requestAnimationFrame(animate)
  }
  
  addHoverEffect() {
    if (!this.animationComplete) return
    
    const svg = this.containerTarget.querySelector('svg')
    if (svg) {
      // Add subtle gold tint to paths
      const paths = svg.querySelectorAll('path')
      paths.forEach(path => {
        path.style.fill = '#f5f0e8' // Slightly warm/golden tinted white
        path.style.filter = 'drop-shadow(0 0 2px rgba(212, 169, 98, 0.3))'
      })
    }
    
    // Add pressed/stamped effect to container
    this.containerTarget.style.transform = 'scale(0.95) translateY(2px)'
    this.containerTarget.style.transition = 'transform 0.15s ease-out'
    
    // Find and enhance the background glow element
    const glowElement = this.containerTarget.parentElement.querySelector('.logo-glow')
    if (glowElement) {
      glowElement.style.background = 'radial-gradient(circle, rgba(212, 169, 98, 0.9) 0%, rgba(212, 169, 98, 0.7) 20%, rgba(212, 169, 98, 0.5) 40%, rgba(212, 169, 98, 0.3) 60%, transparent 80%)'
      glowElement.style.opacity = '1'
      glowElement.style.transform = 'scale(1.5)'
      glowElement.style.filter = 'blur(60px)'
      glowElement.style.transition = 'all 0.3s ease'
    }
  }
  
  removeHoverEffect() {
    if (!this.animationComplete) return
    
    const svg = this.containerTarget.querySelector('svg')
    if (svg) {
      // Reset paths to pure white
      const paths = svg.querySelectorAll('path')
      paths.forEach(path => {
        path.style.fill = 'white'
        path.style.filter = 'none'
      })
    }
    
    // Remove pressed effect
    this.containerTarget.style.transform = 'scale(1) translateY(0)'
    
    // Reset background glow
    const glowElement = this.containerTarget.parentElement.querySelector('.logo-glow')
    if (glowElement) {
      glowElement.style.background = ''
      glowElement.style.opacity = '0'
      glowElement.style.transform = 'scale(1)'
      glowElement.style.filter = ''
    }
  }
  
  easeInOutCubic(t) {
    return t < 0.5
      ? 4 * t * t * t
      : 1 - Math.pow(-2 * t + 2, 3) / 2
  }
  
  easeOutExpo(t) {
    return t === 1 ? 1 : 1 - Math.pow(2, -10 * t)
  }
}
