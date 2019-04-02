$(() => {
  let droppable = url => {
    $('.droppable').droppable({
      drop: e => {
        $.ajax({
          type: 'PUT',
          url: url,
          data: {
            row: $(e.target).data('row'),
            column: $(e.target).data('column'),
          },
        });
      },
    });
  };

  $('.draggable .piece').draggable({
    drag: e => {
      droppable($(e.target).data('url'));
    },
  });
});
