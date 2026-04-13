/* exam_script.js
   Handles:
   - Intake form validation (presentation + demographics both required)
   - Proof panel open/close toggle on results page
   - Auto-open first non-excluded diagnosis
   - Row highlight when a toggle-pill is selected
*/

(function () {
  'use strict';

  /* ── Intake form: require presentation + demographics ──────── */
  var intakeForm = document.getElementById('intakeForm');
  var startBtn   = document.getElementById('startBtn');

  if (intakeForm && startBtn) {
    function checkIntakeReady() {
      var hasPres = !!intakeForm.querySelector('input[name="presentation"]:checked');
      var hasAge  = !!document.getElementById('age').value;
      var hasSex  = !!intakeForm.querySelector('input[name="sex"]:checked');
      startBtn.disabled = !(hasPres && hasAge && hasSex);
    }
    intakeForm.addEventListener('change', checkIntakeReady);
    document.getElementById('age').addEventListener('input', checkIntakeReady);
  }

  /* ── Highlight active row when toggle-pill changes ─────────── */
  document.querySelectorAll('.toggle-pill input[type="radio"]').forEach(function(radio) {
    radio.addEventListener('change', function() {
      var row = this.closest('.q-row');
      if (row) {
        row.classList.add('q-row-answered');
      }
    });
  });

  document.querySelectorAll('.inline-select').forEach(function(sel) {
    sel.addEventListener('change', function() {
      var row = this.closest('.q-row');
      if (row) {
        row.classList.toggle('q-row-answered', this.value !== 'not_reported' && this.value !== 'not_examined');
      }
    });
  });

  document.querySelectorAll('.number-inline').forEach(function(inp) {
    inp.addEventListener('input', function() {
      var row = this.closest('.q-row');
      if (row) {
        row.classList.toggle('q-row-answered', !!this.value);
      }
    });
  });

  /* ── Proof panel toggle ─────────────────────────────────────── */
  window.toggleProof = function (cardId) {
    var card = document.getElementById(cardId);
    if (!card) return;
    card.classList.toggle('open');
  };

  /* ── Auto-open first non-excluded diagnosis ─────────────────── */
  var firstCard = document.querySelector('.dx-card:not(.dx-excluded)');
  if (firstCard) {
    firstCard.classList.add('open');
  }

})();
