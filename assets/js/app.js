import "phoenix_html"
import socket from "./socket"

export var Index = {
  run: function() {
    var key = document.getElementById('Key')
    var value = document.getElementById('Value')
    var store = document.getElementById('Store')

    store.addEventListener('click', function() {
      if (value.value.length > 0) {
        var xhr = new XMLHttpRequest();
        var json_request = JSON.stringify({key: key.value, value: value.value});
        xhr.open("POST", '/insert', true)
        xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8');
        xhr.send(json_request)
      } 
    })
  }
}

export var Lookup = {
  run: function () {
    var key = document.getElementById('key')
    var lookup = document.getElementById('Lookup')
    var channel = socket.channel()

    lookup.addEventListener('click', function () {
      if (key.value.length > 0) {
        lookup_key(key.value)
      }
    })

    key.onblur = function() {
      channel = socket.channel('updates:' + key.value, {});
      channel.on('new_value', function (payload) {
        display_result(payload.value)
      })

      channel.join();
    }

    key.onfocus = function() {
      display.innerHTML = ''
      channel.leave()
    }

    function display_result(value) {
      var display = document.getElementById("display")
      if (value == null) {
        var to_display = "not found"
      } else var to_display = value
      display.innerHTML = '<b><p>Value is: ' + to_display + '</p></b>'
    }

    function lookup_key(key) {
      var xhr = new XMLHttpRequest();
      xhr.open("GET", '/lookup/' + key, false)
      xhr.onload = function() {
        var resp = JSON.parse(xhr.response);
        display_result(resp.value)
      }
      xhr.send()
    }
  }
}