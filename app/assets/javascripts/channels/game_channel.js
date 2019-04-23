$(function() {
  $('[data-channel-subscribe="game"]').each(function(index, element) {
    var $element = $(element),
      game_id = $element.data('game-id');
    App.cable.subscriptions.create(
      {
        channel: 'GameChannel',
        id: game_id,
      },
      {
        received: function(data) {
          alert(data.pieces);
        },
      }
    );
  });
});
