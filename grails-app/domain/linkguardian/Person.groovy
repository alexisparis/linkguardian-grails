package linkguardian

import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.UserDetails

class Person implements UserDetails
{

	transient springSecurityService

	String username
	String password
	boolean enabled
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired

	static constraints = {
		username blank: false, unique: true
		password blank: false
	}

	static mapping = {
		password column: '`password`'
        username index: true
	}
    static hasMany = [links: Link]

	Set<GrantedAuthority> getAuthorities() {
		PersonRole.findAllByUser(this).collect { it.role } as Set
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService.encodePassword(password)
	}

    boolean isAccountNonExpired()
    {
        return ! this.accountExpired
    }

    boolean isAccountNonLocked()
    {
        return ! this.accountLocked
    }

    boolean isCredentialsNonExpired()
    {
        return ! this.passwordExpired
    }
}
