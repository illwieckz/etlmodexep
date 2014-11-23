#! /bin/sh

# Author:  Thomas DEBESSE <dev@illwieckz.net>
# License: ISC

get_cqbtest_name () {
	echo "TrueCombat:Close Quarters Battle"
}
get_cqbtest_original_sum () {
	echo "87f22b5de05a147302cd1b30c88c725b7039bbe03d9bddd40b0cd4b988fef8d1ae7b2485a39d109912675693b45a86f4cc90caa9c53bdf7257d9ffcd5900fb4e"
}
get_cqbtest_patched_sum () {
	echo "765bfc195486af857ea70a2650528953a72f9475c962c25eb075861f1b66bcc9027a2b7a7fb2bd420364b653f0c660216e3b525de06dd71f52b462c808765d68"
}

ask () {
	# $1: string
	printf "%s (Y/n) " "${1}"
	read ans
	[ "x${ans}" = 'x' -o  "x${ans}" = 'xY' -o "x${ans}" = 'xy' ]
}

compare () {
	# $1: path
	# $2: sum
	if [ -f "${1}" ]
	then
		[ "$(sha512sum "${1}" | cut -f1 -d' ')" = "${2}" ]
	else
		false
	fi
}

nop_writer () {
	# $1: count
	i=0
	while [ $i -lt $1 ]
	do
		# The “printf 'kA==' | base64 -d” is equivalent to “printf '\x90'”
		# but more reliable since many printf implementations do not understand hexadecimal sequences.
		# 0x90 is the NOP opcode.
		# We use it to rewrite some broken code, letting jumps in place.
		printf 'kA==' | base64 -d
		i=$(($i + 1))
	done
}

cqbtest_patcher () {
	# $1: filename_original
	dd status=none if="${1}" bs=864709 count=1 \
	&& nop_writer 25 \
	&& dd status=none if="${1}" bs=1 skip=864734 count=6 \
	&& nop_writer 36 \
	&& dd status=none if="${1}" bs=1 skip=864776 count=149 \
	&& nop_writer 16 \
	&& dd status=none if="${1}" bs=864941 skip=1
}

main () {
	filename="${1}"
	filename_original="${filename}.original"
	filename_patched="${filename}.patched"
	already_patched="false"

	if compare "${filename}" "$("get_cqbtest_original_sum")"
	then
		mod_name="cqbtest"
	elif compare "${filename}" "$("get_cqbtest_patched_sum")"
	then
		mod_name="cqbtest"
		already_patched="true"
	else
		echo "ERR: File unknown, will do nothing."
		exit 1
	fi

	echo "Binary file from “$("get_${mod_name}_name")” recognized."

	if [ "${already_patched}" = "true" ]
	then
		echo "Warning: File already patched."
		exit
	fi

	if ! ask "File will be patched, continue?"
	then
		echo "Nothing done."
		exit
	fi

	if ! cp -a "${filename}" "${filename_original}"
	then
		echo "ERR: Can't backup file, nothing done."
		exit 2
	fi

	if ! "${mod_name}_patcher" "${filename_original}" > "${filename_patched}"
	then
		echo "ERR: Something wrong has happened, original file left intact."
		exit 3
	fi

	if ! compare "${filename_patched}" "$("get_${mod_name}_patched_sum")"
	then
		echo "ERR: Malformed patched file, original file left intact."
		exit 4
	fi

	echo "File successfully patched."

	if ! cp "${filename_patched}" "${filename}"
	then
		echo "ERR: Can't overwrite original file with patched one."
		exit 5
	fi

	echo "File successfully overwriten by patched one."
}

main ${@}

#EOF
