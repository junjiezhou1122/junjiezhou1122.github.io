function ChangeColor(){
    var bodyelement = document.getElementById("bodyColor");
    if (bodyelement.style.backgroundColor == FloralWhite){
      bodyelement.className = "Tempo_color";
    }
    else
    {
      bodyelement.className = "body";
    }
  }