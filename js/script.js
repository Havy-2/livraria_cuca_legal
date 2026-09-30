document.addEventListener("DOMContentLoaded", () => {
  const carrinhoEl = document.getElementById("carrinho");
  const formContato = document.getElementById("form-contato");
  const aviso = document.getElementById("ok");
  let qtd = 0;

  document.querySelectorAll(".adicionar").forEach((botao) => {
    botao.addEventListener("click", () => {
      qtd += 1;
      if (carrinhoEl) carrinhoEl.textContent = "Carrinho: " + qtd + " livro(s)";
      botao.textContent = "Adicionado";
      setTimeout(() => { botao.textContent = "Adicionar"; }, 800);
    });
  });

  if (formContato) {
    formContato.addEventListener("submit", (e) => {
      e.preventDefault();
      if (aviso) aviso.style.display = "block";
      formContato.reset();
    });
  }

  const trilha = document.getElementById("trilha");
  const prev = document.getElementById("prev");
  const next = document.getElementById("next");
  const dotsBox = document.getElementById("dots");
  if (trilha && prev && next) {
    const cards = trilha.querySelectorAll(".card");
    let pagina = 0;

    function visiveis() {
      return window.innerWidth <= 800 ? 1 : 3;
    }
    function totalPaginas() {
      return Math.max(1, Math.ceil(cards.length / visiveis()));
    }
    function desenharDots() {
      if (!dotsBox) return;
      dotsBox.innerHTML = "";
      for (let i = 0; i < totalPaginas(); i++) {
        const b = document.createElement("button");
        b.type = "button";
        b.setAttribute("aria-label", "Página " + (i + 1));
        if (i === pagina) b.classList.add("ativo");
        b.addEventListener("click", () => { pagina = i; atualizar(); });
        dotsBox.appendChild(b);
      }
    }
    function atualizar() {
      const max = totalPaginas() - 1;
      if (pagina > max) pagina = max;
      if (pagina < 0) pagina = 0;
      const card = cards[0];
      const estilo = window.getComputedStyle(trilha);
      const gap = parseFloat(estilo.columnGap || estilo.gap) || 22;
      const passo = card.getBoundingClientRect().width + gap;
      trilha.style.transform = "translateX(-" + (pagina * visiveis() * passo) + "px)";
      desenharDots();
    }
    prev.addEventListener("click", () => { pagina -= 1; atualizar(); });
    next.addEventListener("click", () => { pagina += 1; atualizar(); });
    window.addEventListener("resize", atualizar);
    atualizar();
  }
});
