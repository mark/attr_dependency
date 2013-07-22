### attr_dependency

Dependency Injection is becoming more popular in Ruby, despite not being required to solve the problems that dependency injection is designed to solve. Yet stubbing out factory methods in tests doesn't feel like the right solution either. This gem represents a middle road.

Advantages:

(1) Clearly spells out dependencies as part of the class's public interface.
(2) Allows them to be overridden at the class level, or at the level of individual objects