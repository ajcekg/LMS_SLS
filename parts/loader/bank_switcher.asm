	opt h- f+

	org $600
		icl 'loader_config.hea'
		icl 'atari.hea'

set_next_bank	.local
		ldx #0
		lda config_ext_banks,x
		sta portb
		inc set_next_bank+1
		rts
.endl		