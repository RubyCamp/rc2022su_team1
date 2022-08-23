module GlfwHelper
	# GLFW定数へのマッピング
	GLFW_CONSTS = {
		m_left: GLFW_MOUSE_BUTTON_LEFT,     # マウス左ボタン
		m_right: GLFW_MOUSE_BUTTON_RIGHT,   # マウス右ボタン
		m_middle: GLFW_MOUSE_BUTTON_MIDDLE, # マウス右ボタン
		k_up: GLFW_KEY_UP,                  # ↑
		k_down: GLFW_KEY_DOWN,              # ↓
		k_left: GLFW_KEY_LEFT,              # ←
		k_right: GLFW_KEY_RIGHT,            # →
		k_0: GLFW_KEY_0,                    # 0
		k_1: GLFW_KEY_1,                    # 1
		k_2: GLFW_KEY_2,                    # 2
		k_3: GLFW_KEY_3,                    # 3
		k_4: GLFW_KEY_4,                    # 4
		k_5: GLFW_KEY_5,                    # 5
		k_6: GLFW_KEY_6,                    # 6
		k_7: GLFW_KEY_7,                    # 7
		k_8: GLFW_KEY_8,                    # 8
		k_9: GLFW_KEY_9,                    # 9
		k_num0: GLFW_KEY_KP_0,              # テンキー0
		k_num1: GLFW_KEY_KP_1,              # テンキー1
		k_num2: GLFW_KEY_KP_2,              # テンキー2
		k_num3: GLFW_KEY_KP_3,              # テンキー3
		k_num4: GLFW_KEY_KP_4,              # テンキー4
		k_num5: GLFW_KEY_KP_5,              # テンキー5
		k_num6: GLFW_KEY_KP_6,              # テンキー6
		k_num7: GLFW_KEY_KP_7,              # テンキー7
		k_num8: GLFW_KEY_KP_8,              # テンキー8
		k_num9: GLFW_KEY_KP_9,              # テンキー9
		k_add: GLFW_KEY_KP_ADD,             # +
		k_sub: GLFW_KEY_KP_SUBTRACT,        # -
		k_multi: GLFW_KEY_KP_MULTIPLY,      # *
		k_divide: GLFW_KEY_KP_DIVIDE,       # /
		k_decimal: GLFW_KEY_KP_DECIMAL,     # .
		k_a: GLFW_KEY_A,                    # A
		k_b: GLFW_KEY_B,                    # B
		k_c: GLFW_KEY_C,                    # C
		k_d: GLFW_KEY_D,                    # D
		k_e: GLFW_KEY_E,                    # E
		k_f: GLFW_KEY_F,                    # F
		k_g: GLFW_KEY_G,                    # G
		k_h: GLFW_KEY_H,                    # H
		k_i: GLFW_KEY_I,                    # I
		k_j: GLFW_KEY_J,                    # J
		k_k: GLFW_KEY_K,                    # K
		k_l: GLFW_KEY_L,                    # L
		k_m: GLFW_KEY_M,                    # M
		k_n: GLFW_KEY_N,                    # N
		k_o: GLFW_KEY_O,                    # O
		k_p: GLFW_KEY_P,                    # P
		k_q: GLFW_KEY_Q,                    # Q
		k_r: GLFW_KEY_R,                    # R
		k_s: GLFW_KEY_S,                    # S
		k_t: GLFW_KEY_T,                    # T
		k_u: GLFW_KEY_U,                    # U
		k_v: GLFW_KEY_V,                    # V
		k_w: GLFW_KEY_W,                    # W
		k_x: GLFW_KEY_X,                    # X
		k_y: GLFW_KEY_Y,                    # Y
		k_z: GLFW_KEY_Z,                    # Z
		k_esc: GLFW_KEY_ESCAPE,             # ESC
		k_space: GLFW_KEY_SPACE,            # SPACE
		k_enter: GLFW_KEY_ENTER,            # ENTER
		k_rshift: GLFW_KEY_RIGHT_SHIFT,     # 右SHIFT
		k_rctrl: GLFW_KEY_RIGHT_CONTROL,    # 右CTRL
		k_lshift: GLFW_KEY_LEFT_SHIFT,      # 左SHIFT
		k_lctrl: GLFW_KEY_LEFT_CONTROL,     # 左CTRL
		k_tab: GLFW_KEY_TAB,                # TAB
		k_bs: GLFW_KEY_BACKSPACE,           # BS
		k_del: GLFW_KEY_DELETE,             # DEL
		k_insert: GLFW_KEY_INSERT,          # INSERT
		k_home: GLFW_KEY_HOME,              # HOME
		k_end: GLFW_KEY_END,                # END
		k_pup: GLFW_KEY_PAGE_UP,            # PAGE UP
		k_pdown: GLFW_KEY_PAGE_DOWN,        # PAGE DOWN
	}

	GLFW_CONSTS_INVERTED = GLFW_CONSTS.invert
end
