// Portfólio — scripts simples

// Destaque suave no menu ao rolar
const sections = document.querySelectorAll("section[id]");
const navLinks = document.querySelectorAll("nav a");

function updateActiveNav() {
  let current = "";
  sections.forEach((section) => {
    const sectionTop = section.offsetTop - 80;
    if (window.scrollY >= sectionTop) {
      current = section.getAttribute("id");
    }
  });

  navLinks.forEach((link) => {
    link.style.color = "";
    if (link.getAttribute("href") === `#${current}`) {
      link.style.color = "#2563eb";
      link.style.fontWeight = "700";
    }
  });
}

window.addEventListener("scroll", updateActiveNav);
updateActiveNav();

// Ano atual no rodapé (opcional)
console.log("Portfólio carregado — Curso de Desenvolvimento Web");
