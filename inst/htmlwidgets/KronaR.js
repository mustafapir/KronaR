HTMLWidgets.widget({
  name: 'KronaR2',
  type: 'output',
  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        while (el.firstChild) {
          el.removeChild(el.firstChild);
        }

        console.log(x.data);
        var dataKrona = x.message;

        var divdetails = document.createElement("details");
        divdetails.setAttribute("style", "position:absolute;top:1%;right:2%;text-align:right;");
        el.appendChild(divdetails);

        var divoptions = document.createElement("options");
        divoptions.setAttribute("style", "position:absolute;left:0;top:0");
        el.appendChild(divoptions);

        function addData() {
          console.log("redraw");
          var data = "<attributes magnitude='magnitude'>\
                        <attribute display='Total'>magnitude</attribute>\
                        <attribute display='Unassigned'>magnitudeUnassigned</attribute>\
                      </attributes>\
                      <datasets>\
                        <dataset>text</dataset>\
                      </datasets>";

          data += x.data;
          data += dataKrona;
          console.log(data);

          var datel = document.createElement("Krona");
          datel.setAttribute("collapse", "true");
          datel.setAttribute("key", "true");
          datel.innerHTML = data;

          var div = document.createElement("div");
          div.setAttribute("style", "display:none");
          div.appendChild(datel);
          el.appendChild(div);

          load();
        }

        addData();
      },
      resize: function(width, height) {
        // Handle resize to adjust the widget size appropriately
        el.style.width = width + 'px';
        el.style.height = height + 'px';
      }
    };
  }
});
