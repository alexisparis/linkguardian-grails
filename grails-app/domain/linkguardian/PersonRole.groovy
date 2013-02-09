package linkguardian

import org.apache.commons.lang.builder.HashCodeBuilder

class PersonRole implements Serializable {

	Person user
	Role role

	boolean equals(other) {
		if (!(other instanceof PersonRole)) {
			return false
		}

		other.user?.id == user?.id &&
			other.role?.id == role?.id
	}

	int hashCode() {
		def builder = new HashCodeBuilder()
		if (user) builder.append(user.id)
		if (role) builder.append(role.id)
		builder.toHashCode()
	}

	static PersonRole get(long userId, long roleId) {
		find 'from PersonRole where user.id=:userId and role.id=:roleId',
			[userId: userId, roleId: roleId]
	}

	static PersonRole create(Person user, Role role, boolean flush = false) {
		new PersonRole(user: user, role: role).save(flush: flush, insert: true)
	}

	static boolean remove(Person user, Role role, boolean flush = false) {
		PersonRole instance = PersonRole.findByUserAndRole(user, role)
		if (!instance) {
			return false
		}

		instance.delete(flush: flush)
		true
	}

	static void removeAll(Person user) {
		executeUpdate 'DELETE FROM PersonRole WHERE user=:user', [user: user]
	}

	static void removeAll(Role role) {
		executeUpdate 'DELETE FROM PersonRole WHERE role=:role', [role: role]
	}

	static mapping = {
		id composite: ['role', 'user']
		version false
	}
}
