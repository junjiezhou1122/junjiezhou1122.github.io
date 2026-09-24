document.addEventListener("DOMContentLoaded", () => {
  const dialog = document.getElementById("wechat-qr-dialog");
  const closeButton = document.getElementById("wechat-dialog-close");
  const trigger = document.querySelector('.contact-icons a[href="#wechat-qr-dialog"]');
  const qrCode = dialog?.querySelector("img[data-src]");

  if (
    !(dialog instanceof HTMLDialogElement) ||
    !(closeButton instanceof HTMLButtonElement) ||
    !(trigger instanceof HTMLAnchorElement) ||
    !(qrCode instanceof HTMLImageElement) ||
    !qrCode.dataset.src
  ) {
    throw new Error("WeChat dialog initialization failed: required elements are missing.");
  }

  trigger.setAttribute("aria-haspopup", "dialog");
  trigger.setAttribute("aria-controls", dialog.id);

  trigger.addEventListener("click", (event) => {
    event.preventDefault();
    if (qrCode.dataset.loaded !== "true") {
      qrCode.src = qrCode.dataset.src;
      qrCode.dataset.loaded = "true";
    }
    dialog.showModal();
  });

  closeButton.addEventListener("click", () => dialog.close());
  dialog.addEventListener("close", () => trigger.focus());

  dialog.addEventListener("click", (event) => {
    const bounds = dialog.getBoundingClientRect();
    const clickedInside =
      event.clientX >= bounds.left && event.clientX <= bounds.right && event.clientY >= bounds.top && event.clientY <= bounds.bottom;

    if (!clickedInside) dialog.close();
  });
});
