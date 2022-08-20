kbd = Keyboard.new

kbd.init_pins(
  [ 8, 9, 10, 11, 12 ],
  [ 2, 3, 4, 5, 6, 7 ]
)

# default layer should be added at first
kbd.add_layer :default, %i(
  KC_Q      KC_W      KC_E        KC_R      KC_T       KC_Y       KC_U      KC_I      KC_O      KC_P
  KC_A      KC_S      KC_D        KC_F      KC_G       KC_H       KC_J      KC_K      KC_L      KC_SPACE
  Z_LSFT    X_LGUI    C_LALT      V_LCTL    BSP_LOWER  SPC_RAISE  B_RCTL    N_RALT    M_RGUI    KC_ENTER
)
kbd.add_layer :raise, %i(
  KC_EXLM   KC_AT     KC_HASH     KC_DLR    KC_PERC    KC_CIRC    KC_AMPR   KC_ASTER  KC_EQUAL  KC_PLUS
  KC_LABK   KC_LCBR   KC_LBRACKET KC_LPRN   KC_MINUS   KC_LEFT    KC_DOWN   KC_UP     KC_RIGHT  KC_BSPACE
  KC_RABK   KC_RCBR   KC_RBRACKET KC_RPRN   ADJUST     SPC_RAISE  KC_BSLASH KC_COMMA  KC_DOT    KC_SLASH
)
kbd.add_layer :adjust, %i(
  CUT       COPY        PASTE       SSHOT     KC_F5      KC_F6      KC_F7     KC_F8     KC_F9     KC_MUTE
  KC_VOLUP  KC_VOLDOWN  KC_QUOTE    KC_DQUO   KC_MINUS   KC_LEFT    KC_DOWN   KC_UP     KC_RIGHT  FIBONACCI
  KC_ESCAPE KC_LGUI     KC_LALT     KC_LCTL   UNLOCK     UNLOCK     KC_RCTL   KC_RALT   KC_RGUI   PASSWD
)
kbd.add_layer :lower, %i(
  KC_1      KC_2      KC_3        KC_4      KC_5       KC_6       KC_7      KC_8      KC_9      KC_0
  KC_TAB    KC_NO     KC_QUOTE    KC_DQUO   KC_MINUS   KC_GRAVE   KC_TILD   KC_PIPE   KC_COLON  KC_SCOLON
  KC_ESCAPE KC_LGUI   KC_LALT     KC_LCTL   BSP_LOWER  ADJUST     KC_RCTL   KC_RALT   KC_RGUI   KC_RSFT
)
#
#                   Your custom    Keycode or                          Keycode (only modifiers)    Release time     Re-push time
#                   key name       Array of Keycode                    or Layer Symbol to be held  threshold(ms)    threshold(ms)
#                                  or Proc                             or Proc which will run      to consider as   to consider as
#                                  when you click                      while you keep press        `click the key`  `hold the key`
kbd.define_mode_key :Z_LSFT,    [ :KC_Z,                               :KC_LSFT,                   300,             150 ]
kbd.define_mode_key :X_LGUI,    [ :KC_X,                               :KC_LGUI,                   300,             150 ]
kbd.define_mode_key :C_LALT,    [ :KC_C,                               :KC_LALT,                   300,             150 ]
kbd.define_mode_key :V_LCTL,    [ :KC_V,                               :KC_LCTL,                   300,             150 ]
kbd.define_mode_key :B_RCTL,    [ :KC_B,                               :KC_RCTL,                   300,             150 ]
kbd.define_mode_key :N_RALT,    [ :KC_N,                               :KC_RALT,                   300,             150 ]
kbd.define_mode_key :M_RGUI,    [ :KC_M,                               :KC_RGUI,                   300,             150 ]
# kbd.define_mode_key :UNDS_RSFT, [ :KC_UNDS,                            :KC_RSFT,                   150,             150 ]
kbd.define_mode_key :SPC_RAISE, [ :KC_SPACE,                           :raise,                     150,             150 ]
kbd.define_mode_key :BSP_LOWER, [ :KC_BSPACE,                          :lower,                     150,             150 ]
kbd.define_mode_key :ADJUST,    [ Proc.new { kbd.lock_layer :adjust }, :KC_LSFT,                   300,             nil ]
kbd.define_mode_key :UNLOCK,    [ Proc.new { kbd.unlock_layer },       :KC_LSFT,                   300,             nil ]

kbd.define_composite_key :CUT,   %i(KC_LGUI KC_X)
kbd.define_composite_key :COPY,  %i(KC_LGUI KC_C)
kbd.define_composite_key :PASTE, %i(KC_LGUI KC_V)
kbd.define_composite_key :SSHOT, %i(KC_LGUI KC_LSFT KC_4)

# Tip: You can also switch current layer by single click like this:
#   kbd.define_mode_key :RAISE, [ Proc.new { kbd.raise_layer }, :KC_LSFT, 150, nil ]
#   kbd.define_mode_key :LOWER, [ Proc.new { kbd.lower_layer }, :KC_LSFT, 150, nil ]

class Fibonacci
  def initialize
    @a = 0 ; @b = 1
  end
  def take
    result = @a + @b
    @a = @b
    @b = result
  end
end
fibonacci = Fibonacci.new
kbd.define_mode_key :FIBONACCI, [ Proc.new { kbd.macro fibonacci.take }, :KC_NO, 300, nil ]

class Password
  def initialize
    @c = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_!@#$%^&*()=-+/[]{}<>'
  end
  def generate
    unless @srand
      # generate seed with board_millis
      srand(board_millis)
      @srand = true
    end
    password = ""
    while true
      i = rand % 100
      password << @c[i].to_s
      break if password.length == 8
    end
    return password
  end
end
password = Password.new
kbd.define_mode_key :PASSWD, [ Proc.new { kbd.macro password.generate, [] }, :KC_NO, 300, nil ]

kbd.start!
