package com.monkeybusiness;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.AbstractWebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketBrokerConfig extends AbstractWebSocketMessageBrokerConfigurer {

	public void registerStompEndpoints(StompEndpointRegistry arg0) {
		arg0.addEndpoint("/chat").withSockJS();
	}

	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		registry.setApplicationDestinationPrefixes("/app").enableSimpleBroker("/topic","/queue");
	}

	

}
