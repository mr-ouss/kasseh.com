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
    
    // Add hover effect to the container
    this.containerTarget.addEventListener('mouseenter', () => this.addHoverGlow())
    this.containerTarget.addEventListener('mouseleave', () => this.removeHoverGlow())
    
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
      path.style.transition = 'filter 0.3s ease'
      
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
        // Final state - clean white logo with no glow
        paths.forEach(path => {
          path.style.fill = 'white'
          path.style.stroke = 'none'
          path.style.filter = 'none'
        })
      }
    }
    
    requestAnimationFrame(animate)
  }
  
  addHoverGlow() {
    const svg = this.containerTarget.querySelector('svg')
    if (!svg) return
    
    const paths = svg.querySelectorAll('path')
    paths.forEach(path => {
      path.style.filter = 'drop-shadow(0 0 12px rgba(212, 169, 98, 0.4))'
    })
  }
  
  removeHoverGlow() {
    const svg = this.containerTarget.querySelector('svg')
    if (!svg) return
    
    const paths = svg.querySelectorAll('path')
    paths.forEach(path => {
      path.style.filter = 'none'
    })
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
