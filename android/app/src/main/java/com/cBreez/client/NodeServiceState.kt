package com.cBreez.client

/**
 * This class represent the state of the node service.
 * - Off = the service has not started the node
 * - Init = the wallet is starting
 * - Started = the wallet is unlocked and the node will now try to connect and establish channels
 * - Error = the node could not start
 */
sealed class NodeServiceState {

    val name: String by lazy { this.javaClass.simpleName }

    /** Default state, the node is not started. */
    object Off : NodeServiceState()

    /** This is an utility state that is used when the binding between the service holding the state and the consumers of that state is disconnected. */
    object Disconnected : NodeServiceState()
    object Init : NodeServiceState()
    object Running : NodeServiceState()
    data class Error(val cause: Throwable) : NodeServiceState()
}
