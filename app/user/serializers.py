from django.contrib.auth import get_user_model, authenticate
from django.utils.translation import ugettext_lazy as _

from rest_framework import serializers


class UserSerializer(serializers.ModelSerializer):
    """Serializer for the users object"""

    class Meta:
        model = get_user_model()
        # These are the fields that are going to be
        # converted to and from json when we make our HTTP post.
        # Fields that we want to make accesible in the API either read or write
        fields = ('email', 'password', 'name')
        # Extra settings in our ModelSerializer.
        # Password constraint
        extra_kwargs = {'password': {'write_only': True, 'min_length': 5}}

    # A function that is called when we create a new object.
    # Use get_user_model because we want the password stored in encrypted form.
    def create(self, validated_data):
        """Create a new user with encrypted password and return it"""
        return get_user_model().objects.create_user(**validated_data)


class AuthTokenSerializer(serializers.Serializer):
    """Serializer for the user authentication object"""
    email = serializers.CharField()
    password = serializers.CharField(
        style={'input_type': 'password'},
        trim_whitespace=False
    )

    # attrs is every field that make up of the serializer as dict
    def validate(self, attrs):
        """Validate and authenticate the user"""
        email = attrs.get('email')
        password = attrs.get('password')

        user = authenticate(
            request=self.context.get('request'),
            username=email,
            password=password
        )
        if not user:
            msg = _('Unable to authenticate with provided credentials')
            raise serializers.ValidationError(msg, code='authorization')

        attrs['user'] = user
        return attrs
