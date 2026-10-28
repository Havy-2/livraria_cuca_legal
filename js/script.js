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
});
