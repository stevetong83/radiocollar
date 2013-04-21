// Generated by CoffeeScript 1.3.3
(function() {
  var Theatre;

  Theatre = (function() {

    function Theatre(_arg) {
      var backStage, firstScene, stage;
      stage = _arg.stage, firstScene = _arg.firstScene, backStage = _arg.backStage;
      if (stage == null) {
        stage = '#front_stage';
      }
      if (firstScene == null) {
        firstScene = false;
      }
      if (backStage == null) {
        backStage = '#back_stage';
      }
      $(backStage).hide();
      this.stage = $(stage);
      this.sceneHistory = [];
      if (firstScene != null) {
        this.scene = $(firstScene);
      }
      if (firstScene != null) {
        this.render(firstScene);
      }
    }

    Theatre.prototype.goBack = function() {
      var back, previousScene;
      back = this.sceneHistory.length - 1;
      previousScene = this.sceneHistory[back];
      this.scene = $(previousScene);
      this.render(previousScene);
      return this.sceneHistory.pop();
    };

    Theatre.prototype.perform = function(scene) {
      if (this.scene) {
        this.sceneHistory = this.sceneHistory.concat(this.scene.selector);
      }
      this.scene = $(scene);
      return this.render(scene);
    };

    Theatre.prototype.render = function(scene) {
      this.stage.empty();
      return this.stage.html($(scene).html());
    };

    return Theatre;

  })();

  $(function() {
    var radioCollar;
    radioCollar = new Theatre({
      firstScene: '#scene3'
    });
    $('#back').click(function() {
      return radioCollar.goBack();
    });
    $('#second').click(function() {
      return radioCollar.perform('#scene2');
    });
    return $('#first').click(function() {
      return radioCollar.perform('#scene1');
    });
  });

}).call(this);